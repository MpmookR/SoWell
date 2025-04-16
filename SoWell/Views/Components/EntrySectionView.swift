import SwiftUI

struct EntrySectionView: View {
    let date: Date
    let entry: MoodEntry?
    let onTrackMood: (Date) -> Void
    let onEdit: (() -> Void)?
    let onEditDiary: ((Date) -> Void)?
    
    var body: some View {
        if let entry {
            // MARK: - Mood & Diary Sections
            VStack(alignment: .leading, spacing: 24) {
                
                // MARK: - Mood Row
                HStack(spacing: 16) {
                    Image(entry.mood.imageName)
                        .resizable()
                        .frame(width: 48, height: 48)
                        .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Mood:")
                            .font(AppFont.footnote)
                            .foregroundColor(.gray)

                        Text(entry.mood.label.lowercased())
                            .font(AppFont.body)
                    }
                    
                    Spacer()
                    
                    if let onEdit = onEdit {
                            Button(action: onEdit) {
                                Text("Edit")
                                    .font(AppFont.body)
                                    .frame(width: 42, height: 24)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .foregroundColor(.white)
                                    .background(Color.AppColor.button)
                                    .cornerRadius(21)
                            }
                        }
                }
                .padding(.horizontal, 24)
                
                // MARK: - Diary Row
                HStack(spacing: 16) {
                    Circle()
                        .fill(Color(hex: "#F5F5F5"))
                        .frame(width: 48, height: 48)
                        .overlay(
                            Text("✍️")
                                .font(.system(size: 24))
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Diary")
                            .font(AppFont.footnote)
                            .foregroundColor(.gray)
                        
                        Text(entry.diaryText.isEmpty ? "No diary entry" : entry.diaryText)
                            .font(AppFont.body)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        onEditDiary?(date)
                    }) {
                        Text(entry.diaryText.isEmpty ? "Add" : "View")
                            .font(AppFont.body)
                            .frame(width: 42, height: 24)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .foregroundColor(.white)
                            .background(Color.AppColor.button)
                            .cornerRadius(21)
                    }
                }
                .padding(.horizontal, 24)
            }
        } else {
            // MARK: - No Mood Tracked
            Spacer()
            VStack(spacing: 8) {
                Text("No mood tracked")
                    .font(AppFont.caption)
                    .foregroundColor(.secondary)
                
                PrimaryButton(label: "Track Mood")
                    .onTapGesture {
                        onTrackMood(date)
                    }
            }
        }
    }
}
