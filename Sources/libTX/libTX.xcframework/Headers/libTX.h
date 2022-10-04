#include<stdint.h>

char* information(char* request_pointer);

char* convert_manifest(char* request_pointer);

char* compile_transaction_intent(char* request_pointer);
char* decompile_transaction_intent(char* request_pointer);

char* compile_signed_transaction_intent(char* request_pointer);
char* decompile_signed_transaction_intent(char* request_pointer);

char* compile_notarized_transaction_intent(char* request_pointer);
char* decompile_notarized_transaction_intent(char* request_pointer);

char* decompile_unknown_transaction_intent(char* request_pointer);

char* decode_address(char* request_pointer);
char* encode_address(char* request_pointer);

char* sbor_decode(char* request_pointer);
char* sbor_encode(char* request_pointer);

char* extract_abi(char* request_pointer);

char* derive_non_fungible_address_from_public_key(char* request_pointer);
char* derive_non_fungible_address(char* request_pointer);

// Memory management functions
char* __transaction_lib_alloc(int32_t capacity);
void __transaction_lib_free(char* pointer);
