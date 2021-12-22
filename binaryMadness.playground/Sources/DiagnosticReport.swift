import Foundation




public struct DiagnosticReport {
    var gammaRate: Int
    var epsilonRate: Int
    var powerConsumption: Int
    
    /// this always inits at the zero position
    public init() { gammaRate = 0; epsilonRate = 0; powerConsumption = 0 }
}

extension DiagnosticReport {
    /// I use a struct so I will internally recreate a new one instead of changing the exixting one
    private init(gammaRate: Int, epsilonRate: Int, powerConsumption: Int) {
        self.gammaRate = gammaRate
        self.epsilonRate = epsilonRate
        self.powerConsumption = powerConsumption
    }
    
    func setNewValues(gammaRate: Int, epsilonRate: Int, powerConsumption: Int) -> DiagnosticReport {
        let powerConsumption = gammaRate * epsilonRate
        return DiagnosticReport(gammaRate: gammaRate, epsilonRate: self.epsilonRate, powerConsumption: powerConsumption)
    }
}
