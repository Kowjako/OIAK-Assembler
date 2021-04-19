.global main

.data
    msg1: .ascii "Please input first double\n\0"
    msg2: .ascii "Please input second double\n\0"
    menu: .ascii "Please input operation (int)\n1. Add\n2. Sub\n3. Div\n4. Mult\n\0"
    control: .ascii "Please input rouding (int)\n1. Cut\n2. Up\n3. Down\n4. Nearest\n\0"
    output: .ascii "Your output\n\0"

    first_d: .double 1.0
    second_d: .double 2.0
    output_d: .double 0.0

    operation: .int 0
    control_operation: .int 0

    format_d: .ascii "%lf\0"
    format_s: .ascii "%s\0"
    format_i: .ascii "%i\0"

    control_word: .short 0x037f #standardowa wartosc z instrukcji
    endline: .ascii "\n\0"
.text