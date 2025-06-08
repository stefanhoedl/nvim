# ~/.config/fish/functions/winboot.fish
function winboot --description "Reboots into Windows via GRUB"
    # Find the line number of the Windows menu entry in grub.cfg
    # The 'f' in your original grep command was removed as it appears to be an error.
    set -l windows_entry_num (sudo grep -E '^menuentry' /boot/grub/grub.cfg | grep -n Windows | cut -d':' -f 1)

    # Check if a Windows entry was found
    if test -z "$windows_entry_num"
        echo "Error: Windows boot entry not found in GRUB configuration. Please check /boot/grub/grub.cfg." >&2
        return 1
    end

    echo "Rebooting into Windows (GRUB entry number: $windows_entry_num)..."
    # Execute grub-reboot and then reboot only if grub-reboot was successful
    sudo grub-reboot "$windows_entry_num"; and reboot
end
