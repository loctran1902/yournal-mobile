import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    var session: AVCaptureSession
    
    static func dismantleUIView(_ uiView: UIView, coordinator: ()) {
        // Clean up the preview layer when the view is destroyed
        uiView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
    }
    
    func makeUIView(context: Context) -> UIView {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            // Return a simple UIView for previews
            return UIView()
        }
        
        let view = UIView(frame: .zero)
        let previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.bounds
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            return
        }
        
        if let previewLayer = uiView.layer.sublayers?.first as? AVCaptureVideoPreviewLayer {
            previewLayer.session = session
            previewLayer.frame = uiView.bounds
        }
    }
}

struct MainView: View {
    @StateObject private var cameraManager = CameraManager()
    @State private var showingMomentsList = false
    @State private var showingNewMoment = false
    
    var body: some View {
        ZStack {
            // Camera Preview
            CameraPreview(session: cameraManager.session)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: { /* settings */ }) {
                        Image(systemName: "gear")
                            .font(.title2)
                    }
                    Spacer()
                }
                .padding()
                
                Spacer()
                
                // Bottom Controls
                HStack {
                    Button(action: { showingMomentsList.toggle() }) {
                        Image(systemName: "photo.stack")
                            .font(.title)
                    }
                    
                    Spacer()
                    
                    // Capture Button
                    Button(action: {
                        cameraManager.capturePhoto()
                        showingNewMoment = true
                    }) {
                        ZStack {
                            Circle()
                                .strokeBorder(.white, lineWidth: 3)
                                .frame(width: 80, height: 80)
                            Circle()
                                .fill(.white)
                                .frame(width: 70, height: 70)
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: { /* switch camera */ }) {
                        Image(systemName: "camera.rotate")
                            .font(.title)
                    }
                }
                .padding()
                .foregroundColor(.white)
            }
        }
        .sheet(isPresented: $showingMomentsList) {
            MomentListView()
        }
//        .sheet(isPresented: $showingNewMoment) {
//            NewMomentView(image: cameraManager.recentImage)
//        }
    }
}

#Preview {
    MainView()
        .environmentObject(MockCameraManager())
}

// Add this class at the bottom of the file
class MockCameraManager: CameraManager {
    override init() {
        super.init()
        // Create a mock session that can be safely used in previews
        DispatchQueue.main.async {
            self.objectWillChange.send()
        }
    }
}

// Optional: Add a preview-only view to better visualize the camera preview
struct PreviewMockView: View {
    var body: some View {
        ZStack {
            Color.black
            
            // Add a camera icon or placeholder image
            Image(systemName: "camera.fill")
                .font(.system(size: 70))
                .foregroundColor(.white.opacity(0.5))
        }
    }
}

// Modify CameraPreview to use mock view in previews
extension CameraPreview {
    static func mockPreview() -> some View {
        PreviewMockView()
    }
}
