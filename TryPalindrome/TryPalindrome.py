from collections import Counter

def can_form_palindrome(s: str) -> str:
    cnt = Counter(s.strip())
    odds = [c for c, n in cnt.items() if n % 2]
    
    if len(odds) > 1:
        return "No"
    
    half = ''.join(c * (n // 2) for c, n in cnt.items())
    mid = odds[0] if odds else ''
    
    return f'Yes ("{half}{mid}{half[::-1]}")'

print(can_form_palindrome(input()))