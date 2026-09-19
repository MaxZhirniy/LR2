#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <unordered_set>
#include <algorithm>
#include <cctype>
using namespace std;

bool is_allowed_char(char c) {
    return isalnum(c) || c == '.';
}

bool validate_local(const string& local) {
    if (local.length() < 6 || local.length() > 30) {
        return false;
    }
    
    for (char c : local) {
        if (!is_allowed_char(c)) {
            return false;
        }
    }
    
    if (local.find("..") != string::npos) {
        return false;
    }
    
    if (!local.empty() && local[0] == '.') {
        return false;
    }
    
    if (!local.empty() && local.back() == '.') {
        return false;
    }
    
    return true;
}

string normalize(const string& email) {
    size_t at_pos = email.find('@');
    if (at_pos == string::npos) {
        return "";
    }
    
    string local = email.substr(0, at_pos);
    string domain = email.substr(at_pos + 1);
    
    if (domain.empty()) {
        return "";
    }
    
    
    size_t plus_pos = local.find('+');
    string local_before_plus = (plus_pos != string::npos) ? 
                                local.substr(0, plus_pos) : local;
    
    string clean_local;
    for (char c : local_before_plus) {
        if (c != '.') {
            clean_local += c;
        }
    }
    
    if (!validate_local(local_before_plus)) {
        return "";
    }
    
    if (clean_local.empty()) {
        return "";
    }
    
    if (!local.empty() && local[0] == '+') {
        return "";
    }
    transform(domain.begin(), domain.end(), domain.begin(), ::tolower);
    
    return clean_local + "@" + domain;
}

int main() {
    ifstream file("input.txt");
    if (!file.is_open()) {
        cerr << "Cannot open input.txt" << endl;
        return 1;
    }
    
    unordered_set<string> unique_emails;
    string line;
    
    while (getline(file, line)) {
        stringstream ss(line);
        string email;
        
        while (getline(ss, email, ',')) {
            size_t start = email.find_first_not_of(" \t\r\n");
            size_t end = email.find_last_not_of(" \t\r\n");
            
            if (start == string::npos) {
                continue;
            }
            
            email = email.substr(start, end - start + 1);
            
            string normalized = normalize(email);
            if (!normalized.empty()) {
                unique_emails.insert(normalized);
            }
        }
    }
    
    cout << unique_emails.size() << endl;
    
    return 0;
}