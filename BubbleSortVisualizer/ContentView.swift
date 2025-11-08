import SwiftUI

struct ContentView: View {
    @State private var inputText: String = ""
    @State private var numbers: [Int] = []
    @State private var explanation: [String] = []
    @State private var isSorting = false
    @State private var delay: Double = 0.5

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("🧠 Bubble Sort Tutor")
                .font(.title)
                .bold()

            TextField("Enter numbers (e.g. 5, 3, 8, 1)", text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            HStack {
                Button("Load Numbers") {
                    loadNumbers()
                }
                .disabled(isSorting)

                Button("Start Bubble Sort") {
                    startSorting()
                }
                .disabled(isSorting || numbers.isEmpty)
            }

            Text("Current Numbers: \(numbers.map { String($0) }.joined(separator: ", "))")
                .padding(.top, 8)

            ScrollView {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(explanation.indices, id: \.self) { i in
                        Text(explanation[i])
                            .font(.system(size: 14, weight: .regular, design: .monospaced))
                    }
                }
            }
            .frame(maxHeight: 300)
            .padding(.top, 8)
            .border(Color.gray.opacity(0.3))

            HStack {
                Text("Speed:")
                Slider(value: $delay, in: 0.05...1.0, step: 0.05)
            }
            .padding(.top)

            Spacer()
        }
        .padding()
    }

    func loadNumbers() {
        let input = inputText
            .split(separator: ",")
            .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }

        numbers = input
        explanation.removeAll()
        explanation.append("Loaded numbers: \(numbers.map { String($0) }.joined(separator: ", "))")
    }

    func startSorting() {
        isSorting = true
        explanation.append("Starting bubble sort...")
        Task {
            await bubbleSort()
            explanation.append("Sorting complete!")
            isSorting = false
        }
    }

    func bubbleSort() async {
        var nums = numbers
        let count = nums.count

        for i in 0..<count {
            for j in 0..<count - i - 1 {
                explanation.append("Comparing \(nums[j]) and \(nums[j + 1])")
                if nums[j] > nums[j + 1] {
                    explanation.append("→ Swapping \(nums[j]) and \(nums[j + 1])")
                    nums.swapAt(j, j + 1)
                } else {
                    explanation.append("→ No swap needed")
                }

                numbers = nums
                try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
        }
    }
}
