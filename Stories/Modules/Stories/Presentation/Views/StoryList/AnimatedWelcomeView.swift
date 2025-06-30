//
//  AnimatedWelcomeView.swift
//  Stories
//
//  Created by Jeremy Ben Abu on 30/06/2025.
//
import SwiftUI

struct AnimatedWelcomeView: View {
    @State private var showTitle = false
    @State private var showSubtitle = false
    @State private var showName = false
    @State private var showContactOptions = false

    @EnvironmentObject var module: StoriesModule

    var body: some View {
        VStack(spacing: 0) {
            VStack(spacing: 4) {
                Spacer()
                Text("Hello Voodoo")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .animatedAppearance(showTitle, offset: CGSize(width: 0, height: 20), duration: 1.0)
                Text("Technical challenge")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
                    .animatedAppearance(showSubtitle, offset: CGSize(width: 0, height: 20), duration: 1.0)
                Spacer(minLength: 50)
                footerView
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.9))
                    .animatedAppearance(showName, offset: CGSize(width: 0, height: 20), duration: 1.0)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.purple, Color.blue]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(radius: 6)
            )
            .padding(.horizontal)
        }
        .padding(.top)
        .onAppear {
            withAnimation {
                showTitle = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation {
                    showSubtitle = true
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation {
                    showName = true
                }
            }
        }
    }

    private var footerView: some View {
        VStack(spacing: 12) {
            if let url = URL(string: AppConfiguration.jeremyAvatarUrl) {
                module.buildCacheImageView(url: url)
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .shadow(radius: 3)
            }

            VStack(spacing: 4) {
                Text("Jeremy BEN ABU")
                    .font(.headline)
                    .foregroundColor(.white)
                Text(verbatim: "jeremy.benabu@gmail.com")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                Text("+33(0)621411194")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
            }
            .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 20)
        .onTapGesture {
            showContactOptions = true
        }
        .confirmationDialog("Contact Jeremy", isPresented: $showContactOptions, titleVisibility: .visible) {
            Button("Send Email") {
                if let url = URL(string: "mailto:jeremy.benabu@gmail.com") {
                    UIApplication.shared.open(url)
                }
            }
            Button("Call Phone") {
                if let url = URL(string: "tel:+33621411194") {
                    UIApplication.shared.open(url)
                }
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}
