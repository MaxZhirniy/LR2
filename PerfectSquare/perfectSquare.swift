import Foundation

func isPerfectSquare(_ n: Int64) -> Bool {
    let sqrt = Int64(Double(n).squareRoot())
    return sqrt * sqrt == n || 
           (sqrt + 1) * (sqrt + 1) == n || 
           (sqrt - 1) * (sqrt - 1) == n
}

func main() {
    var count = 0
    
    while let line = readLine() {
        let trimmed = line.trimmingCharacters(in: .whitespaces)
        
        guard !trimmed.isEmpty else { break }
        
        let tokens = trimmed
            .replacingOccurrences(of: ",", with: " ")
            .components(separatedBy: .whitespaces)
            .filter { !$0.isEmpty }
        
        for token in tokens {
            if let num = Int64(token), num >= 0 {
                if isPerfectSquare(num) {
                    count += 1
                }
            } else {
                fputs("Error: Invalid input\n", stderr)
                exit(1)
            }
        }
    }
    
    print(count)
}

main()