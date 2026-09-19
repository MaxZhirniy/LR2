import java.io.File

fun isAllowedChar(c: Char): Boolean {
    return c in 'a'..'z' || c in 'A'..'Z' || c in '0'..'9' || c == '.'
}

fun validateLocal(local: String): Boolean {
    if (local.length < 6 || local.length > 30) {
        return false
    }
    if (!local.all { isAllowedChar(it) }) {
        return false
    }
    if (local.contains("..")) {
        return false
    }
    if (local.startsWith('.')) {
        return false
    }
    if (local.endsWith('.')) {
        return false
    }
    return true
}

fun normalize(email: String): String? {
    val atPos = email.indexOf('@')
    if (atPos == -1) return null
    val local = email.substring(0, atPos)
    val domain = email.substring(atPos + 1)
    if (domain.isEmpty()) return null
    val localBeforePlus = local.substringBefore('+')
    
    val cleanLocal = localBeforePlus.filter { it != '.' }
    
    if (!validateLocal(localBeforePlus)) return null
    
    if (cleanLocal.isEmpty()) return null
    
    if (local.startsWith('+')) return null
    
    val normalizedDomain = domain.toLowerCase()
    
    return "$cleanLocal@$normalizedDomain"
}

fun main() {
    val file = File("input.txt")
    if (!file.exists()) {
        println("Cannot open input.txt")
        return
    }
    
    val uniqueEmails = mutableSetOf<String>()
    
    file.forEachLine { line ->
        line.split(',').forEach { email ->
            val trimmed = email.trim()
            if (trimmed.isEmpty()) return@forEach
            
            normalize(trimmed)?.let { normalized ->
                uniqueEmails.add(normalized)
            }
        }
    }
    
    println(uniqueEmails.size)
}