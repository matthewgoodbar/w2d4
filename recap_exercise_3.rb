def no_dupes?(arr)
    count = Hash.new(0)
    arr.each {|el| count[el] += 1}
    count.select! {|k,v| v == 1}
    return count.keys
end

# p no_dupes?([1, 1, 2, 1, 3, 2, 4])         # => [3, 4]
# p no_dupes?(['x', 'x', 'y', 'z', 'z'])     # => ['y']
# p no_dupes?([true, true, true])            # => []

def no_consecutive_repeats?(arr)
    (0...(arr.length-1)).each do |i|
        return false if arr[i] == arr[i+1]
    end
    return true
end

# p no_consecutive_repeats?(['cat', 'dog', 'mouse', 'dog'])     # => true
# p no_consecutive_repeats?(['cat', 'dog', 'dog', 'mouse'])     # => false
# p no_consecutive_repeats?([10, 42, 3, 7, 10, 3])              # => true
# p no_consecutive_repeats?([10, 42, 3, 3, 10, 3])              # => false
# p no_consecutive_repeats?(['x'])                              # => true

def char_indices(str)
    indices = Hash.new {|h,k| h[k] = []}
    str.each_char.with_index {|char, i| indices[char] << i}
    return indices
end

# p char_indices('mississippi')   # => {"m"=>[0], "i"=>[1, 4, 7, 10], "s"=>[2, 3, 5, 6], "p"=>[8, 9]}
# p char_indices('classroom')     # => {"c"=>[0], "l"=>[1], "a"=>[2], "s"=>[3, 4], "r"=>[5], "o"=>[6, 7], "m"=>[8]}

def longest_streak(str)
    parts = partition(str)
    max_len = (parts.max_by(&:length)).length
    parts.select! {|el| el.length == max_len}
    return parts.last
end

def partition(str)
    res = []
    partitioned = false
    until partitioned
        partitioned = true
        (0...(str.length-1)).each do |i|
            if str[i] != str[i+1]
                partitioned=false
                res << str[0..i]
                str = str[i+1..-1]
                break
            end
        end
    end
    res << str
    return res
end

# p longest_streak('a')           # => 'a'
# p longest_streak('accccbbb')    # => 'cccc'
# p longest_streak('aaaxyyyyyzz') # => 'yyyyy
# p longest_streak('aaabbb')      # => 'bbb'
# p longest_streak('abc')         # => 'c'

def bi_prime?(num)
    (2..num/2).each do |factor|
        if num % factor == 0
            return true if prime?(factor) && prime?(num/factor)
        end
    end
    return false
end

def prime?(num)
    return num < 2 ? false : (2..num/2).none? { |x| num % x == 0 }
end

# p bi_prime?(14)   # => true
# p bi_prime?(22)   # => true
# p bi_prime?(25)   # => true
# p bi_prime?(94)   # => true
# p bi_prime?(24)   # => false
# p bi_prime?(64)   # => false

def vigenere_cipher(str, arr)
    alphabet = "abcdefghijklmnopqrstuvwxyz"
    res = ""
    key_len = arr.length
    str.each_char.with_index do |char, i|
        alpha_ind = alphabet.index(char)
        res << alphabet[(alpha_ind + (arr[i % key_len])) % 26]
    end
    return res
end

# p vigenere_cipher("toerrishuman", [1])        # => "upfssjtivnbo"
# p vigenere_cipher("toerrishuman", [1, 2])     # => "uqftsktjvobp"
# p vigenere_cipher("toerrishuman", [1, 2, 3])  # => "uqhstltjxncq"
# p vigenere_cipher("zebra", [3, 0])            # => "ceerd"
# p vigenere_cipher("yawn", [5, 1])             # => "dbbo"

def vowel_rotate(str)
    chars = str.split("")
    vowel_ref = ["a","e","i","o","u"]
    consonants = chars - vowel_ref
    vowels = chars - consonants
    vowels = [vowels[-1], *vowels[0...-1]]
    res = ""
    str.each_char do |char|
        if vowel_ref.include?(char)
            res += vowels.shift
        else
            res += consonants.shift
        end
    end
    return res
end

# p vowel_rotate('computer')      # => "cempotur"
# p vowel_rotate('oranges')       # => "erongas"
# p vowel_rotate('headphones')    # => "heedphanos"
# p vowel_rotate('bootcamp')      # => "baotcomp"
# p vowel_rotate('awesome')       # => "ewasemo"

class String
    def select(&blc)
        res = ""
        return res if blc == nil
        self.each_char {|char| res += char if blc.call(char) }
        return res
    end

    def map!(&blc)
        (0...self.length).each {|i| self[i] = blc.call(self[i], i)}
    end
end

# p "app academy".select { |ch| !"aeiou".include?(ch) }   # => "pp cdmy"
# p "HELLOworld".select { |ch| ch == ch.upcase }          # => "HELLO"
# p "HELLOworld".select          # => ""

# word_1 = "Lovelace"
# word_1.map! do |ch| 
#     if ch == 'e'
#         '3'
#     elsif ch == 'a'
#         '4'
#     else
#         ch
#     end
# end
# p word_1        # => "Lov3l4c3"

# word_2 = "Dijkstra"
# word_2.map! do |ch, i|
#     if i.even?
#         ch.upcase
#     else
#         ch.downcase
#     end
# end
# p word_2        # => "DiJkStRa"

def multiply(a, b)
    positive = a.negative? == b.negative?
    return 0 if a == 0 || b == 0
    return a if b == 1
    return positive ? a.abs + multiply(a.abs, (b.abs)-1) : 0 - (a.abs + multiply(a.abs, (b.abs)-1))
end

# p multiply(3, 5)        # => 15
# p multiply(5, 3)        # => 15
# p multiply(2, 4)        # => 8
# p multiply(0, 10)       # => 0
# p multiply(-3, -6)      # => 18
# p multiply(3, -6)       # => -18
# p multiply(-3, 6)       # => -18

def lucas_sequence(n)
    return [] if n == 0
    return [2] if n == 1
    return [2,1] if n == 2
    last_lucas = lucas_sequence(n-1)
    return last_lucas << last_lucas[-1] + last_lucas[-2]
end

# p lucas_sequence(0)   # => []
# p lucas_sequence(1)   # => [2]    
# p lucas_sequence(2)   # => [2, 1]
# p lucas_sequence(3)   # => [2, 1, 3]
# p lucas_sequence(6)   # => [2, 1, 3, 4, 7, 11]
# p lucas_sequence(8)   # => [2, 1, 3, 4, 7, 11, 18, 29]

def prime_factorization(num)
    return [num] if prime?(num)
    (2..num/2).each do |factor|
        if num % factor == 0 && prime?(factor)
            return [factor, *prime_factorization(num/factor)]
        end
    end
end

# p prime_factorization(12)     # => [2, 2, 3]
# p prime_factorization(24)     # => [2, 2, 2, 3]
# p prime_factorization(25)     # => [5, 5]
# p prime_factorization(60)     # => [2, 2, 3, 5]
# p prime_factorization(7)      # => [7]
# p prime_factorization(11)     # => [11]
# p prime_factorization(2017)   # => [2017]