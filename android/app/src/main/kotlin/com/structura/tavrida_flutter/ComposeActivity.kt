package com.structura.tavrida_flutter

import android.annotation.SuppressLint
import android.content.Intent
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.systemBarsPadding
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.google.android.filament.Engine
import com.structura.tavrida_flutter.ui.theme.SceneviewTheme
import com.google.ar.core.Anchor
import com.google.ar.core.Config
import com.google.ar.core.Frame
import com.google.ar.core.Plane
import com.google.ar.core.TrackingFailureReason
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
import io.github.sceneview.math.Transform
import io.github.sceneview.math.toFloat3
import io.github.sceneview.model.ModelInstance
import io.github.sceneview.node.CubeNode
import io.github.sceneview.node.ModelNode
import io.github.sceneview.rememberCollisionSystem
import io.github.sceneview.rememberEngine
import io.github.sceneview.rememberMaterialLoader
import io.github.sceneview.rememberModelLoader
import io.github.sceneview.rememberNode
import io.github.sceneview.rememberNodes
import io.github.sceneview.rememberOnGestureListener
import io.github.sceneview.rememberView
import io.github.sceneview.safeDestroyCamera
import io.github.sceneview.safeDestroyEntity
import io.github.sceneview.safeDestroyTransformable
import java.io.File

private const val kModelFile = "models/model-11.glb"
private const val kMaxModelInstances = 10

class ComposeActivity : ComponentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContent {
            SceneviewTheme {
                Box(
                    modifier = Modifier.fillMaxSize(),
                ) {
                    var isActivated by remember { mutableStateOf(true) }
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
                                        }
                                }
                            },
                            onGestureListener = rememberOnGestureListener(
                                onSingleTapConfirmed = { motionEvent, node ->
                                    if (node == null) {
                                        val hitResults =
                                            frame?.hitTest(motionEvent.x, motionEvent.y)
                                        hitResults?.firstOrNull {
                                            it.isValid(
                                                depthPoint = false,
                                                point = false
                                            )
                                        }?.createAnchorOrNull()
                                            ?.let { anchor ->
                                                planeRenderer = false
                                                childNodes += createAnchorNode(
                                                    engine = engine,
                                                    modelLoader = modelLoader,
                                                    materialLoader = materialLoader,
                                                    modelInstances = modelInstances,
                                                    anchor = anchor
                                                )
                                            }
                                    }
                                })
                        )
                        Text(
                            modifier = Modifier
                                .systemBarsPadding()
                                .fillMaxWidth()
                                .align(Alignment.TopCenter)
                                .padding(top = 16.dp, start = 32.dp, end = 32.dp),
                            textAlign = TextAlign.Center,
                            fontSize = 28.sp,
                            color = Color.White,
                            text = trackingFailureReason?.let {
                                it.getDescription(LocalContext.current)
                            } ?: if (childNodes.isEmpty()) {
                                "Наведите на горизонтальную поверхность"
                            } else {
                                "Вращайте модель двумя пальцами\n" + "перемещайте модель долгим нажатием\n"
                            }
                        )
                    }
                    Box(
                        modifier = Modifier
                            .size(48.dp)
                            .background(
                                color = Color(0xffFFFFFF).copy(alpha = 0.4f),
                                shape = CircleShape
                            )
                            .padding(10.dp)
                            .clickable {
                                isActivated = false
                                val replyIntent = Intent()
                                replyIntent.putExtra(REPLY_MESSAGE, "фвывфы")
                                setResult(RESULT_OK, replyIntent)
                                finish()
                            },
                        contentAlignment = Alignment.Center
                    ) {
                        Icon(
                            imageVector = Icons.Default.ArrowBack,
                            contentDescription = "Back",
                            tint = Color(0xff0A0E15)
                        )
                    }
//                    Text(
//                        modifier = Modifier
//                            .systemBarsPadding()
//                            .fillMaxWidth()
//                            .align(Alignment.TopCenter)
//                            .padding(top = 16.dp, start = 32.dp, end = 32.dp),
//                        textAlign = TextAlign.Center,
//                        fontSize = 28.sp,
//                        color = Color.White,
//                        text = trackingFailureReason?.let {
//                            it.getDescription(LocalContext.current)
//                        } ?: if (childNodes.isEmpty()) {
//                            stringResource("фвы")
//                        } else {
//                            stringResource("фвы")
//                        }
//                    )
                }
            }
        }
    }

    companion object {
        const val ARG_KEY = "argKey"
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
            scaleToUnits = 0.5f
        ).apply {
            // Model Node needs to be editable for independent rotation from the anchor rotation
            isEditable = true
        }
//        Log.d("message", "This is a debug message")
//        Log.d("message", modelNode.playingAnimations.toString())
        val boundingBoxNode = CubeNode(
            engine,
            size = modelNode.extents,
            center = modelNode.center,
            materialInstance = materialLoader.createColorInstance(Color.White.copy(alpha = 0.5f))
        ).apply {
            isVisible = false
        }
        modelNode.addChildNode(boundingBoxNode)
        anchorNode.addChildNode(modelNode)

        listOf(modelNode, anchorNode).forEach {
            it.onEditingChanged = { editingTransforms ->
                boundingBoxNode.isVisible = editingTransforms.isNotEmpty()
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