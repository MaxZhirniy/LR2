use std::collections::HashMap;

fn main() {
    // Чтение строки
    let mut input = String::new();
    std::io::stdin().read_line(&mut input).unwrap();
    let s = input.trim();
    
    // Подсчёт символов
    let mut counts = HashMap::new();
    for ch in s.chars() {
        let count = counts.entry(ch).or_insert(0);
        *count += 1;
    }
    
    // Проверка на возможность палиндрома
    let mut odd_chars = 0;
    for &count in counts.values() {
        if count % 2 == 1 {
            odd_chars += 1;
        }
    }
    
    if odd_chars > 1 {
        println!("No");
        return;
    }
    
    // Построение палиндрома
    let mut left_half = String::new();
    let mut middle = String::new();
    
    for (ch, &count) in &counts {
        let half_count = count / 2;
        left_half.push_str(&ch.to_string().repeat(half_count));
        
        if count % 2 == 1 {
            middle.push(*ch);
        }
    }
    
    let right_half: String = left_half.chars().rev().collect();
    let palindrome = format!("{}{}{}", left_half, middle, right_half);
    
    println!("Yes (\"{}\")", palindrome);
}