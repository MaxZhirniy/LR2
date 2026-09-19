import java.io.*;
import java.util.*;

public class UniqueEmail {
    public static void main(String[] args) throws IOException {
        BufferedReader reader = new BufferedReader(new FileReader("input.txt"));
        Set<String> uniqueEmails = new HashSet<>();
        String line;
        
        while ((line = reader.readLine()) != null) {
            for (String email : line.split(",")) {
                email = email.trim();
                if (email.isEmpty()) continue;
                
                String normalized = normalize(email);
                if (normalized != null) {
                    uniqueEmails.add(normalized);
                }
            }
        }
        reader.close();
        
        System.out.println(uniqueEmails.size());
    }
    
    static String normalize(String email) {
        int atIdx = email.indexOf('@');
        if (atIdx == -1) return null;
        
        String local = email.substring(0, atIdx);
        String domain = email.substring(atIdx + 1);
        if (domain.isEmpty()) return null;
        
        // Обрезаем по '+'
        int plusIdx = local.indexOf('+');
        String localBeforePlus = plusIdx != -1 ? local.substring(0, plusIdx) : local;
        
        // Валидируем
        if (!isValidLocal(localBeforePlus)) return null;
        if (local.startsWith("+")) return null;
        
        // Удаляем точки
        StringBuilder clean = new StringBuilder();
        for (int i = 0; i < localBeforePlus.length(); i++) {
            char c = localBeforePlus.charAt(i);
            if (c != '.') clean.append(c);
        }
        if (clean.length() == 0) return null;
        
        return clean.toString() + "@" + domain.toLowerCase();
    }
    
    static boolean isValidLocal(String s) {
        if (s.length() < 6 || s.length() > 30) return false;
        if (s.startsWith(".") || s.endsWith(".")) return false;
        if (s.contains("..")) return false;
        
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            if (!((c >= 'a' && c <= 'z') || 
                    (c >= 'A' && c <= 'Z') || 
                    (c >= '0' && c <= '9') || 
                    c == '.')) return false;
        }
        return true;
    }
}