# BUnit
Very simple testing framework for Bash. No additional installation is required, you just source the lib as follows

    source <(curl -s "https://raw.githubusercontent.com/qetools/bunit/0.0.2/test.sh")

# Usage

Before writing tests, please update your code so that it is not executed when it is sourced by another script.

    main() {
      <MAIN_CODE>
    }

    [[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"

Then, we can easily source the script from a test script

    source "./your_script.sh"

