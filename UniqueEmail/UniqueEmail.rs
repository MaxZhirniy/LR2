use std::collections::HashSet;
use std::fs::File;
use std::io::{self, BufRead, BufReader};

/// Входит ли символ в список разрешенных
fn is_allowed_char(c: char) -> bool {
    matches!(c, 'a'..='z' | 'A'..='Z' | '0'..='9' | '.')
}

/// Проверка локальной части на соответствие всем ограничениям
fn validate_local(local: &str) -> bool {
    // Длина от 6 до 30 знаков
    if local.len() < 6 || local.len() > 30 {
        return false;
    }
    
    // Проверка что все символы только разрешённые
    if !local.chars().all(is_allowed_char) {
        return false;
    }
    
    // Несколько точек подряд
    if local.contains("..") {
        return false;
    }
    
    // Не может начинаться с точки
    if local.starts_with('.') {
        return false;
    }
    
    // Не может заканчиваться точкой
    if local.ends_with('.') {
        return false;
    }
    
    true
}

fn normalize(email: &str) -> Option<String> {
    // Находим '@'
    let at_pos = email.find('@')?;
    let local = &email[..at_pos];
    let domain = &email[at_pos + 1..];
    
    // Проверяем, что домен не пустой
    if domain.is_empty() {
        return None;
    }
    
    // --- Обработка локальной части ---
    
    // 1. Обрезаем всё после '+' (включая сам '+')
    let local_before_plus = match local.find('+') {
        Some(plus_pos) => &local[..plus_pos],
        None => local,
    };
    
    // 2. Удаляем все точки для нормализации
    let clean_local: String = local_before_plus
        .chars()
        .filter(|&c| c != '.')
        .collect();
    
    // 3. Проверяем оригинальную локальную часть (до удаления точек и '+')
    //    на соответствие всем ограничениям
    if !validate_local(local_before_plus) {
        return None;
    }
    
    // 4. После удаления точек локальная часть не должна быть пустой
    if clean_local.is_empty() {
        return None;
    }
    
    // 5. Проверяем, что локальная часть не начиналась с '+' (краевой случай)
    if local.starts_with('+') {
        return None;
    }
    
    // --- Обработка домена ---
    let domain = domain.to_lowercase();
    
    Some(format!("{}@{}", clean_local, domain))
}

fn main() -> io::Result<()> {
    let file = File::open("input.txt")?;
    let reader = BufReader::new(file);
    
    let mut unique_emails = HashSet::new();
    let mut valid_count = 0;
    
    for line in reader.lines(){
        let line = line?;
        
        for email in line.split(',') {
            let email = email.trim();
            if email.is_empty() {
                continue;
            }
            
            match normalize(email) {
                Some(normalized) => {
                    unique_emails.insert(normalized);
                    valid_count += 1;
                } None =>{
                    continue;
                }
            }
        }
    }
    
    println!("{}", unique_emails.len());
    
    Ok(())
}