import SwiftUI

struct ScreenshotView: View {
    @Binding var screenShot: Image?
    @Binding var isShowPhoto: Bool
    
    var body: some View {
        ZStack (alignment: .bottom) {
            screenShot?
                .resizable()
                .scaledToFit()
            HStack {
                Button(
                    action: {
                        self.screenShot = nil
                    }
                ) {
                    HStack {
                        Image(systemName: "arrow.counterclockwise.circle.fill")
                        Spacer()
                            .frame(width: 8)
                        Text(
                            "Переснять"
                        )
                        .font(.system(
                            size: 16,
                            weight: .medium
                        ))
                        .foregroundStyle(Color(
                            red: 0.149,
                            green: 0.153,
                            blue: 0.196
                        ))
                    }
                }
                .padding(
                    [.vertical],
                    13
                )
                .padding(
                    [.horizontal],
                    23.5
                )
                .frame(
                    //width: 160,
                    height: 48
                )
                .background(Color(
                    red: 0.973,
                    green: 0.973,
                    blue: 0.973
                ))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(
                            Color(
                                red: 0.149,
                                green: 0.153,
                                blue: 0.196
                            ),
                            lineWidth: 1
                        )
                )
                .cornerRadius(24)
                Spacer()
                    .frame(width: 14)
                Button(
                    action: {
                        guard let inputImage = self.screenShot?.asUIImage() else { return }

                            let imageSaver = ImageSaver()
                            imageSaver.writeToPhotoAlbum(image: inputImage)
                        self.isShowPhoto = true
                    }
                ) {
                    HStack {
                        Image(systemName: "arrow.counterclockwise.circle.fill")
                        Spacer()
                            .frame(width: 8)
                        Text(
                            "Переснять"
                        )
                        .font(.system(
                            size: 16,
                            weight: .medium
                        ))
                        .foregroundStyle(Color(
                            red: 0.149,
                            green: 0.153,
                            blue: 0.196
                        ))
                    }
                }
                .padding(
                    [.vertical],
                    13
                )
                .padding(
                    [.horizontal],
                    23.5
                )
                .frame(
                    //width: 160,
                    height: 48
                )
                .background(Color(
                    red: 0.973,
                    green: 0.973,
                    blue: 0.973
                ))
                .overlay(
                    RoundedRectangle(cornerRadius: 24)
                        .stroke(
                            Color(
                                red: 0.149,
                                green: 0.153,
                                blue: 0.196
                            ),
                            lineWidth: 1
                        )
                )
                .cornerRadius(24)
            }
            .padding(
                [.vertical],
                20
            )
        }
        .padding(
            [.all],
            20
        )
        .frame(
            width: UIScreen.main.bounds.size.width,
            height: UIScreen.main.bounds.size.height - 246
        )
    }
}
