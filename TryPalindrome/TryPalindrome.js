const readline = require('readline');

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

rl.on('line', (s) => {
    s = s.trim();
    
    const cnt = {};
    for (const c of s) {
        cnt[c] = (cnt[c] || 0) + 1;
    }
    
    let odd = 0;
    let oddChar = null;
    for (const c in cnt) {
        if (cnt[c] % 2 === 1) {
            odd++;
            oddChar = c;
        }
    }
    
    if (odd > 1) {
        console.log("No");
        rl.close();
        return;
    }
    
    let half = "";
    for (const c in cnt) {
        half += c.repeat(Math.floor(cnt[c] / 2));
    }
    
    let pal = half;
    if (oddChar) {
        pal += oddChar;
    }
    pal += half.split('').reverse().join('');
    
    console.log(`Yes ("${pal}")`);
    rl.close();
});