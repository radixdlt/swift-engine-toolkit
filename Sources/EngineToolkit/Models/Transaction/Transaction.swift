import Foundation


public struct TransactionManifest: Sendable, Codable, Hashable {
    // ===============
    // Struct members
    // ===============
    
    public let instructions: ManifestInstructions
    public let blobs: [[UInt8]]
    
    // =============
    // Constructors
    // =============
    
    public init(
        instructions: ManifestInstructions,
        blobs: [[UInt8]] = []
    ) {
        self.instructions = instructions
        self.blobs = blobs
    }
    
    public init(
        instructions: [Instruction],
        blobs: [[UInt8]] = []
    ) {
        self.init(
            instructions: .json(instructions),
            blobs: blobs
        )
    }
    
    public init(
        instructions: [any InstructionProtocol],
        blobs: [[UInt8]] = []
    ) {
        self.init(
            instructions: instructions.map { $0.embed() },
            blobs: blobs
        )
    }
}


extension TransactionManifest {
    
    @resultBuilder
    struct InstructionsBuilder {
        static func buildBlock(_ instructions: Instruction...) -> [Instruction] {
            instructions
        }
        static func buildBlock(_ instruction: Instruction) -> [Instruction] {
            [instruction]
        }
        static func buildBlock(_ instruction: Instruction) -> Instruction {
            instruction
        }
    }
    
    @resultBuilder
    struct SpecificInstructionsBuilder {
        static func buildBlock(_ instructions: any InstructionProtocol...) -> [any InstructionProtocol] {
            instructions
        }
        static func buildBlock(_ instruction: any InstructionProtocol) -> [any InstructionProtocol] {
            [instruction]
        }
        static func buildBlock(_ instruction: any InstructionProtocol) -> any InstructionProtocol {
            instruction
        }
    }
    
    init(@InstructionsBuilder buildInstructions: () throws -> [Instruction]) rethrows{
        try self.init(instructions: buildInstructions())
    }
 
    init(@SpecificInstructionsBuilder buildInstructions: () throws -> [any InstructionProtocol]) rethrows {
        try self.init(instructions: buildInstructions())
    }
 
}
