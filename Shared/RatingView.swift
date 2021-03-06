//
//  RatingView.swift
//  BookWorm
//
//  Created by Erik Mikac on 4/20/21.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Int
    
    var label = ""
    var maximumRating = 5
    
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color.gray
    var onColor = Color.yellow
    
    
    var body: some View {
        HStack {
            if label.isEmpty == false {
                Text(label)
            } else {
                ForEach(1..<maximumRating) { number in
                    self.image(for: number)
                        .foregroundColor(number > self.rating
                                            ? self.offColor : self.onColor)
                        .onTapGesture {
                            self.rating = number
                        }
                    
                }
            }
        }
    }
    
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage ?? onImage
        }
        return onImage
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        RatingView(rating: .constant(4))
    }
}
