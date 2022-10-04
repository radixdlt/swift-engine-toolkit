import Foundation

public enum InstructionKind: String, Codable {
    case CallFunction = "CALL_FUNCTION"
    case CallMethod = "CALL_METHOD"
    
    case TakeFromWorktop = "TAKE_FROM_WORKTOP"
    case TakeFromWorktopByAmount = "TAKE_FROM_WORKTOP_BY_AMOUNT"
    case TakeFromWorktopByIds = "TAKE_FROM_WORKTOP_BY_IDS"
    
    case ReturnToWorktop = "RETURN_TO_WORKTOP"
    
    case AssertWorktopContains = "ASSERT_WORKTOP_CONTAINS"
    case AssertWorktopContainsByAmount = "ASSERT_WORKTOP_CONTAINS_BY_AMOUNT"
    case AssertWorktopContainsByIds = "ASSERT_WORKTOP_CONTAINS_BY_IDS"
    
    case PopFromAuthZone = "POP_FROM_AUTH_ZONE"
    case PushToAuthZone = "PUSH_TO_AUTH_ZONE"
    
    case ClearAuthZone = "CLEAR_AUTH_ZONE"
    
    case CreateProofFromAuthZone = "CREATE_PROOF_FROM_AUTH_ZONE"
    case CreateProofFromAuthZoneByAmount = "CREATE_PROOF_FROM_AUTH_ZONE_BY_AMOUNT"
    case CreateProofFromAuthZoneByIds = "CREATE_PROOF_FROM_AUTH_ZONE_BY_IDS"
    case CreateProofFromBucket = "CREATE_PROOF_FROM_BUCKET"
    
    case CloneProof = "CLONE_PROOF"
    case DropProof = "DROP_PROOF"
    case DropAllProofs = "DROP_ALL_PROOFS"
    
    case PublishPackage = "PUBLISH_PACKAGE"
    
    case CreateResource = "CREATE_RESOURCE"
    case BurnBucket = "BURN_BUCKET"
    case MintFungible = "MINT_FUNGIBLE"
}
