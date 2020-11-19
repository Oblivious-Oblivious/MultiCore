require "./types.so"

def main
    s = Types::Scan.new("192.168.1.8", "4888", "ll");
    s.print;
end
main;
