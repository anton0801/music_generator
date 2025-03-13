import SwiftUI
import SDWebImageSwiftUI

struct CreateTrackView: View {
    
    @EnvironmentObject var trackVm: TrackViewModel
    @EnvironmentObject var musicPlayer: MusicPlayerViewModel
    
    @State var styleMusic = ""
    @State var lyrics = ""
    @State var title = ""
    @State var prompt = ""
    
    @State var error: String? = nil
    
    var body: some View {
        ZStack {
            VStack {
                Text("Create you own song")
                    .font(.custom("NunitoSans-12ptExtraLight_Bold", size: 24))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.init(red: 213/255, green: 34/255, blue: 53/255))
                
                PulsatingBarsView()
                    .padding(.top, 32)
                
                Text("Style of music")
                    .font(.custom("NunitoSans-12ptExtraLight_Regular", size: 16))
                    .foregroundColor(.black)
                    .padding(.top, 32)
                
                TextField("Style", text: $styleMusic)
                    .font(.custom("NunitoSans-12ptExtraLight_Regular", size: 18))
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.init(red: 213/255, green: 34/255, blue: 53/255))
                    )
                    .padding(.horizontal)
                
                Text("Author")
                    .font(.custom("NunitoSans-12ptExtraLight_Regular", size: 16))
                    .foregroundColor(.black)
                    .padding(.top, 6)
                
                TextField("Author", text: $lyrics)
                    .font(.custom("NunitoSans-12ptExtraLight_Regular", size: 18))
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.init(red: 213/255, green: 34/255, blue: 53/255))
                    )
                    .padding(.horizontal)
                
                Text("Title")
                    .font(.custom("NunitoSans-12ptExtraLight_Regular", size: 16))
                    .foregroundColor(.black)
                    .padding(.top, 6)
                
                TextField("Title", text: $title)
                    .font(.custom("NunitoSans-12ptExtraLight_Regular", size: 18))
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.init(red: 213/255, green: 34/255, blue: 53/255))
                    )
                    .padding(.horizontal)
                
                Text("Prompt")
                    .font(.custom("NunitoSans-12ptExtraLight_Regular", size: 16))
                    .foregroundColor(.black)
                    .padding(.top, 6)
                
                TextField("prompt", text: $prompt)
                    .font(.custom("NunitoSans-12ptExtraLight_Regular", size: 18))
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.init(red: 213/255, green: 34/255, blue: 53/255))
                    )
                    .padding(.horizontal)
                
                if let error = error {
                    Text(error)
                        .foregroundColor(Color.init(red: 213/255, green: 34/255, blue: 53/255))
                        .font(.custom("NunitoSans-12ptExtraLight_Regular", size: 18))
                }
                
                Button {
                    error = nil
                    if styleMusic.isEmpty {
                        error = "Enter style of music"
                        return
                    }
                    if lyrics.isEmpty {
                        error = "Enter author of music"
                        return
                    }
                    if title.isEmpty {
                        error = "Enter title of music"
                        return
                    }
                    if prompt.isEmpty {
                        error = "Enter prompt of music"
                        return
                    }
                    
                    Task {
                        try await trackVm.generateTrack(prompt: prompt, style: styleMusic, title: title, author: lyrics)
                    }
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.init(red: 213/255, green: 34/255, blue: 53/255))
                            .frame(width: 72, height: 72)
                        Text("Create")
                            .font(.custom("NunitoSans-12ptExtraLight_Regular", size: 18))
                            .foregroundColor(.white)
                    }
                }
                .padding(.top, 12)
                
                Spacer()
            }
            
            if trackVm.generatingTrack {
                if trackVm.trackGenerated {
                    let generatedTrack = trackVm.tracks.last
                    if let generatedTrack = generatedTrack {
                        VStack {
                            HStack {
                                Spacer()
                                Button {
                                    styleMusic = ""
                                    lyrics = ""
                                    title = ""
                                    prompt = ""
                                    trackVm.currentTrack = nil
                                    trackVm.generatingTrack = false
                                    trackVm.trackGenerated = false
                                } label: {
                                    Text("Close")
                                        .foregroundColor(.white)
                                }
                            }
                            .padding()
                            Spacer()
                            
                            WebImage(url: URL(string: generatedTrack.imageUrl))
                                .resizable()
                                .frame(width: 240, height: 240)
                                .cornerRadius(12)
                            
                            Text(generatedTrack.title)
                                .font(.custom("NunitoSans-12ptExtraLight_Bold", size: 20))
                                .foregroundColor(.white)
                            
                            Text(generatedTrack.author)
                                .font(.custom("NunitoSans-12ptExtraLight_Regular", size: 14))
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Button {
                                if musicPlayer.currentTrack?.title != generatedTrack.title {
                                    musicPlayer.currentTrack = generatedTrack
                                }
                                if musicPlayer.isPlaying {
                                    musicPlayer.pause()
                                } else {
                                    musicPlayer.playTrack(generatedTrack)
                                }
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(Color.init(red: 213/255, green: 34/255, blue: 53/255))
                                        .frame(width: 72, height: 72)
                                    if musicPlayer.isPlaying {
                                        Image("pause_btn")
                                    } else {
                                        Image("play_btn")
                                    }
                                }
                            }
                            
                            HStack {
                                Spacer()
                            }
                            
                            Spacer()
                        }
                        .background(
                            Rectangle()
                                .fill(.black)
                                .opacity(0.7)
                        )
                        .ignoresSafeArea()
                    }
                } else {
                    VStack {
                        Spacer()
                        
                        PulsatingBarsView()
                            .padding(.top, 42)
                        
                        Text("Loading")
                            .font(.custom("NunitoSans-12ptExtraLight_Bold", size: 20))
                            .foregroundColor(.white)
                        
                        HStack {
                            Spacer()
                        }
                        
                        Spacer()
                    }
                    .background(
                        Rectangle()
                            .fill(.black)
                            .opacity(0.7)
                    )
                    .ignoresSafeArea()
                }
            }
        }
    }
}

struct PulsatingBarsView: View {
    @State private var isAnimating = false
    
    private let baseHeights: [CGFloat] = [50, 100, 150, 100, 50]
    private let maxScale: CGFloat = 1.2
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<5) { index in
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .frame(width: 20, height: baseHeights[index])
                    .foregroundColor(Color.init(red: 213/255, green: 34/255, blue: 53/255))
                    .scaleEffect(y: isAnimating ? maxScale : 0.1, anchor: .bottom)
                    .animation(
                        Animation.easeInOut(duration: 0.8)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.1),
                        value: isAnimating
                    )
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    CreateTrackView()
        .environmentObject(TrackViewModel())
        .environmentObject(MusicPlayerViewModel())
}
