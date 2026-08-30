#![cfg_attr(target_os = "solana", no_std)]

#[cfg(target_os = "solana")]
use core::panic::PanicInfo;

#[cfg(target_os = "solana")]
#[panic_handler]
fn panic(_info: &PanicInfo<'_>) -> ! {
    loop {}
}

#[cfg(target_os = "solana")]
#[no_mangle]
pub extern "C" fn entrypoint(_input: *mut u8) -> u64 {
    0
}

#[cfg(test)]
mod tests {
    #[test]
    fn host_test_runner_works() {
        assert_eq!(2 + 2, 4);
    }
}
