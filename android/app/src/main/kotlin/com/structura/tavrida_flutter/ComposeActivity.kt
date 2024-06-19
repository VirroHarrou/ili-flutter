package com.structura.tavrida_flutter

import android.annotation.SuppressLint
import android.content.Intent
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.systemBarsPadding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.automirrored.filled.ArrowBack
import androidx.compose.material.icons.outlined.Info
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.ModalBottomSheet
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.rememberModalBottomSheetState
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.shadow
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.res.vectorResource
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.google.android.filament.Engine
import com.google.ar.core.Anchor
import com.google.ar.core.Config
import com.google.ar.core.Frame
import com.google.ar.core.Plane
import com.google.ar.core.TrackingFailureReason
import com.structura.tavrida_flutter.ui.theme.SceneviewTheme
import io.github.sceneview.ar.ARScene
import io.github.sceneview.ar.arcore.createAnchorOrNull
import io.github.sceneview.ar.arcore.getUpdatedPlanes
import io.github.sceneview.ar.arcore.isValid
import io.github.sceneview.ar.getDescription
import io.github.sceneview.ar.node.ARCameraNode
import io.github.sceneview.ar.node.AnchorNode
import io.github.sceneview.collision.Vector3
import io.github.sceneview.loaders.MaterialLoader
import io.github.sceneview.loaders.ModelLoader
import io.github.sceneview.math.Position
import io.github.sceneview.math.Rotation
import io.github.sceneview.math.Transform
import io.github.sceneview.math.toFloat3
import io.github.sceneview.model.ModelInstance
import io.github.sceneview.node.CubeNode
import io.github.sceneview.node.ModelNode
import io.github.sceneview.rememberCollisionSystem
import io.github.sceneview.rememberEngine
import io.github.sceneview.rememberMainLightNode
import io.github.sceneview.rememberMaterialLoader
import io.github.sceneview.rememberModelLoader
import io.github.sceneview.rememberNode
import io.github.sceneview.rememberNodes
import io.github.sceneview.rememberOnGestureListener
import io.github.sceneview.rememberView
import io.github.sceneview.safeDestroyCamera
import io.github.sceneview.safeDestroyEntity
import io.github.sceneview.safeDestroyTransformable
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import java.io.File
import kotlin.time.Duration.Companion.seconds

private const val kMaxModelInstances = 1

class ComposeActivity : ComponentActivity() {
    private var scale = 0

    @OptIn(ExperimentalMaterial3Api::class)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            val sheetState = rememberModalBottomSheetState()
            val scope = rememberCoroutineScope()
            var showBottomSheet by remember { mutableStateOf(false) }
            Scaffold { contentPadding ->
                if (showBottomSheet) {
                    ModalBottomSheet(
                        onDismissRequest = { showBottomSheet = false },
                        sheetState = sheetState,
                    ) {
                        Column (
                            modifier = Modifier
                                .fillMaxWidth()
                                .height(200.dp)
                                .padding(bottom = 20.dp, start = 20.dp, end = 20.dp),
                        ) {
                            Text(
                                text = intent.getStringExtra("title") ?: "Название пропало",
                                fontWeight = FontWeight.W600,
                                fontSize = 20.sp,
                                lineHeight = 26.sp,
                                color = Color(0xFF262732),
                            )
                            Text(
                                modifier = Modifier
                                    .padding(top = 16.dp),
                                text = intent.getStringExtra("description") ?: "Описание отсутствует",
                                fontSize = 14.sp,
                                lineHeight = 20.sp,
                                fontWeight = FontWeight(400),
                                color = Color(0xFF262732),
                            )
                        }
                    }
                }
                SceneviewTheme {
                    Box(
                        modifier = Modifier
                            .fillMaxSize()
                            .padding(contentPadding),
                    ) {
                        var isActivated by remember { mutableStateOf(true) }
                        var textVisible by remember { mutableStateOf(true) }


                        if (isActivated) {
                            val argValue = intent.getStringExtra(ARG_KEY)
                            val engine = rememberEngine()
                            val modelLoader = rememberModelLoader(engine)
                            val materialLoader = rememberMaterialLoader(engine)
                            val camera = rememberCameraNode2(engine)
                            val childNodes = rememberNodes()
                            val view = rememberView(engine)
                            val collisionSystem = rememberCollisionSystem(view)

                            var planeRenderer by remember { mutableStateOf(false) }

                            val modelInstances = remember { mutableListOf<ModelInstance>() }
                            var trackingFailureReason by remember {
                                mutableStateOf<TrackingFailureReason?>(null)
                            }
                            var frame by remember { mutableStateOf<Frame?>(null) }

                            val mainLightNode = rememberMainLightNode(engine).apply {
                                intensity = 100_000.0f
                                isShadowCaster = true
                                transform = Transform(position = Position(0.0f, 0.0f, 0.0f), rotation = Rotation(0.0f, 1.0f, 0.0f))
                            }

                            ARScene(
                                modifier = Modifier.fillMaxSize(),
                                childNodes = childNodes,
                                engine = engine,
                                view = view,
                                modelLoader = modelLoader,
                                collisionSystem = collisionSystem,
                                sessionConfiguration = { session, config ->
                                    config.depthMode =
                                        when (session.isDepthModeSupported(Config.DepthMode.AUTOMATIC)) {
                                            true -> Config.DepthMode.AUTOMATIC
                                            else -> Config.DepthMode.DISABLED
                                        }
                                    config.instantPlacementMode = Config.InstantPlacementMode.LOCAL_Y_UP
                                    config.lightEstimationMode =
                                        Config.LightEstimationMode.ENVIRONMENTAL_HDR
                                },
                                cameraNode = camera,
                                planeRenderer = planeRenderer,
                                onTrackingFailureChanged = {
                                    trackingFailureReason = it
                                },
                                onSessionUpdated = { session, updatedFrame ->
                                    frame = updatedFrame

                                    if (childNodes.isEmpty()) {
                                        updatedFrame.getUpdatedPlanes()
                                            .firstOrNull { it.type == Plane.Type.HORIZONTAL_UPWARD_FACING }
                                            ?.let { it.createAnchorOrNull(it.centerPose) }
                                            ?.let { anchor ->
                                                childNodes += createAnchorNode(
                                                    engine = engine,
                                                    modelLoader = modelLoader,
                                                    materialLoader = materialLoader,
                                                    modelInstances = modelInstances,
                                                    anchor = anchor
                                                )

                                                childNodes += mainLightNode
                                            }
                                    }
                                },
                                onGestureListener = rememberOnGestureListener(
//                                    onSingleTapConfirmed = { motionEvent, node ->
//                                        if (!childNodes.isEmpty()) null
//                                        if (node == null) {
//                                            val hitResults =
//                                                frame?.hitTest(motionEvent.x, motionEvent.y)
//                                            hitResults?.firstOrNull {
//                                                it.isValid(
//                                                    depthPoint = false,
//                                                    point = false
//                                                )
//                                            }?.createAnchorOrNull()
//                                                ?.let { anchor ->
//                                                    planeRenderer = false
//                                                    childNodes += createAnchorNode(
//                                                        engine = engine,
//                                                        modelLoader = modelLoader,
//                                                        materialLoader = materialLoader,
//                                                        modelInstances = modelInstances,
//                                                        anchor = anchor
//                                                    )
//                                                }
//                                        }
//                                    }
                                )
                            )
                            Column (
                                modifier = Modifier,
                                verticalArrangement = Arrangement.Top,
                                horizontalAlignment = Alignment.Start
                            ) {
                                IconButton(
                                    modifier = Modifier
                                        .padding(start = 20.dp, top = 20.dp)
                                        .size(52.dp)
                                        .background(
                                            color = Color.White.copy(alpha = 0.4f),
                                            shape = CircleShape
                                        ),
                                    onClick = {
                                        isActivated = false
                                        val replyIntent = Intent()
                                        replyIntent.putExtra(REPLY_MESSAGE, "фвывфы")
                                        setResult(RESULT_OK, replyIntent)
                                        finish()
                                    }
                                ) {
                                    Icon(
                                        modifier = Modifier
                                            .size(28.dp),
                                        imageVector = Icons.AutoMirrored.Default.ArrowBack,
                                        contentDescription = "Back",
                                        tint = Color(0xff0A0E15)
                                    )
                                }
                                if (textVisible || trackingFailureReason?.getDescription(LocalContext.current) != null) {
                                    Text(
                                        modifier = Modifier
                                            .systemBarsPadding()
                                            .fillMaxWidth()
                                            .padding(top = 16.dp, start = 20.dp, end = 20.dp),
                                        textAlign = TextAlign.Center,
                                        fontSize = 16.sp,
                                        fontWeight = FontWeight(600),
                                        color = Color.White,
                                        text = trackingFailureReason?.getDescription(LocalContext.current)
                                            ?: if (childNodes.isEmpty()) {
                                                "Наведите на горизонтальную поверхность"
                                            } else {
                                                LaunchedEffect(Unit) {
                                                    delay(5.seconds)
                                                    textVisible = false
                                                }
                                                "Вращайте модель двумя пальцами\n" + "перемещайте модель долгим нажатием\n"
                                            }
                                    )
                                    if (childNodes.isEmpty()) {
                                        Icon(
                                            imageVector = ImageVector.vectorResource(id = R.drawable.wi_horizon_alt),
                                            modifier = Modifier
                                                .shadow(
                                                    elevation = 16.dp,
                                                    spotColor = Color(0x33000000),
                                                    ambientColor = Color(0x33000000)
                                                )
                                                .align(Alignment.CenterHorizontally)
                                                .width(75.dp)
                                                .height(75.dp),
                                            tint = Color.White,
                                            contentDescription = "ar_hint"
                                        )
                                    }
                                }
                            }
                            IconButton(
                                modifier = Modifier
                                    .padding(20.dp)
                                    .size(32.dp)
                                    .align(Alignment.BottomEnd),
                                onClick = {
                                    scope.launch {
                                        if (!sheetState.isVisible){
                                            showBottomSheet = true
                                        }
                                    }
                                }
                            ) {
                                Icon(
                                    modifier = Modifier
                                        .size(28.dp),
                                    imageVector = Icons.Outlined.Info,
                                    contentDescription = "Info",
                                    tint = Color.White
                                )
                            }
                        }

                    }
                }
            }
        }
    }

    companion object {
        const val ARG_KEY = "path"
        const val REPLY_MESSAGE: String = "reply_message"
    }

    @SuppressLint("SdCardPath")
    fun createAnchorNode(
        engine: Engine,
        modelLoader: ModelLoader,
        materialLoader: MaterialLoader,
        modelInstances: MutableList<ModelInstance>,
        anchor: Anchor
    ): AnchorNode {
        val argValue = intent.getStringExtra(ARG_KEY) ?: ""
        val anchorNode = AnchorNode(engine = engine, anchor = anchor)
        val modelNode = ModelNode(
            modelInstance = modelInstances.apply {
                if (isEmpty()) {
                    this += modelLoader.createInstancedModel(File(argValue), kMaxModelInstances)
                }
            }.removeLast(),
            // Scale to fit in a 0.5 meters cube
            scaleToUnits = .5f
        ).apply {
            // Model Node needs to be editable for independent rotation from the anchor rotation
            isEditable = true
            editableScaleRange = 0.15f..1f
        }
        modelNode.onScale = { gestureDetector, event, scaleFactor -> true
//            if (scaleFactor > 1.1 || scaleFactor < 0.9) false
//            else true
        }
        anchorNode.addChildNode(modelNode)

        listOf(modelNode, anchorNode).forEach {
            it.onEditingChanged = { editingTransforms ->
//                boundingBoxNode.isVisible = editingTransforms.isNotEmpty()
            }
        }
        return anchorNode
    }
}

class CameraNode2(engine: Engine) : ARCameraNode(engine = engine) {

    init {
        transform = Transform(position = Vector3.back().toFloat3())
        setExposure(
            aperture = 16.0f,
            sensitivity = 100.0f,
            shutterSpeed = 1.0f / 125.0f
        )
    }

    override fun destroy() {
        engine.safeDestroyCamera(camera)

        runCatching { parent = null }
        engine.safeDestroyTransformable(entity)
        engine.safeDestroyEntity(entity)
    }
}

@Composable
fun rememberCameraNode2(engine: Engine): ARCameraNode =
    rememberNode {
        CameraNode2(engine)
    }