#include <iostream>
#include <cmath>

using namespace std;

bool isPerfectSquare(int n) {
    if (n < 0) return false;
    int sqrt_n = (int)sqrt(n);
    return sqrt_n * sqrt_n == n || 
           (sqrt_n + 1) * (sqrt_n + 1) == n || 
           (sqrt_n - 1) * (sqrt_n - 1) == n;
}

int main() {
    int N;
    cin >> N;
    int count = 0;

    for (int i = 0; i < N; i++) {
        int num;
        cin >> num;
        if (isPerfectSquare(num)) {
            count++;
        }
    }
    cout << count << endl;
    return 0;
}