import Foundation
import FirebaseFirestore
import FirebaseAuth

//struct FirebaseMoodService {
//    
//    static func uploadMood(date: Date, mood: Mood, diary: String) {
//        guard let userId = Auth.auth().currentUser?.uid else {
//            print("No user logged in. Cannot upload to Firestore.")
//            return
//        }
//        
//        let db = Firestore.firestore()
//        
//        let docRef = db.collection("users")
//                       .document(userId)
//                       .collection("moodEntries")
//                       .document(dateFormatted(date))
//        
//        let data: [String: Any] = [
//            "date": Timestamp(date: date),
//            "mood": mood.label,
//            "imageName": mood.imageName,
//            "diaryText": diary
//        ]
//        
//        docRef.setData(data) { error in
//            if let error = error {
//                print("Error uploading mood to Firestore: \(error.localizedDescription)")
//            } else {
//                print("Mood successfully uploaded to Firestore!")
//            }
//        }
//    }
//    
//    //create document IDs in Firestore.
//    private static func dateFormatted(_ date: Date) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        return formatter.string(from: date)
//    }
//}


