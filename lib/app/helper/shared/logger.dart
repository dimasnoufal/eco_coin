// Information or Warning
import 'dart:developer' as developer;

void printInfo(String text) {
  developer.log('\x1B[33m$text\x1B[0m');
}

// Error
void printX(String text) {
  developer.log('\x1B[31m$text\x1B[0m');
}

// Success
void printY(String text) {
  developer.log('\x1B[32m$text\x1B[0m');
}
