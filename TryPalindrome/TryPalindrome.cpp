#include <iostream>
#include <string>
#include <unordered_map>
#include <algorithm>

using namespace std;

int main() {
    string str;
    cin >> str;
    
    unordered_map<char, int> cnt;
    for (char c : str) {
        cnt[c]++;
    }
    
    int odd = 0;
    char odd_char = 0;
    for (pair<const char, int>P : cnt) {
        char c = P.first;
        int n = P.second;
        if (n & 1) {
            odd++;
            odd_char = c;
        }
    }
    
    if (odd > 1) {
        cout << "No\n";
        return 0;
    }
    
    string half, pal;
    for (pair<const char, int>P : cnt) {
        char c = P.first;
        int n = P.second;
        half += string(n / 2, c);
    }
    pal = half;
    if (odd) {
        pal += odd_char;
    }
    reverse(half.begin(), half.end());
    pal += half;
    cout << "Yes (\"" << pal << "\")\n";
    return 0;
}