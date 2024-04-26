namespace Sample {
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Measurement;

    @EntryPoint()
    operation main() : Unit {
        Message("Starting");
        let code : Int[] = [0, 1, 1, 0];

        let n = Length(code);
        let result = BernsteinVaziraniAlgorithm(code);
        Message("Result");
        for i in 0..n-1 {
            Message(ResultAsString(result[i]));

        }
    }

    function ResultAsString(result : Result) : String {
        if result == One {
            return "One"
        } else { 
            return "Zero"; 
        }
    }

    operation BernsteinVaziraniAlgorithm(code : Int[]) : Result[] {
        let n = Length(code);
        use (register, aux) = (Qubit[n], Qubit()) {
            // Prepare the auxiliary qubit in the |-> state
            X(aux);
            H(aux);

            // Apply Hadamard to each qubit in the register
            ApplyToEach(H, register);

            // Apply Controlled-Hadamard based on the 'code'
            for i in 0..n-1 {
                if (code[i] == 1) {
                    Controlled H([register[i]], aux);
                }
            }

            // Apply another round of Hadamards to the register
            ApplyToEach(H, register);

            // Measure each qubit in the register individually in the Z basis
            mutable results : Result[] = [];
            for i in 0..n-1 {
                set results += [ M(register[i])];
            }

            ResetAll(register + [aux]);
            return results;
        }
    }
}