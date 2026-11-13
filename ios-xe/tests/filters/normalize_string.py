# Copyright: (c) 2025, Daniel Schmidt <danischm@cisco.com>


class Filter:
    name = "normalize_string"

    @classmethod
    def filter(cls, text):
        """Normalize a string by replacing Robot Framework special characters with escaped representations.

        Replaces double spaces with ${SPACE}${SPACE}, newlines with \\n,
        carriage returns with \\r, and tabs with \\t. Also escapes leading
        and trailing single spaces as ${SPACE} to prevent Robot Framework
        from stripping them during argument parsing.

        Args:
            text: The string to normalize. If not a string, returns unchanged.

        Returns:
            str: The normalized string with escaped special characters.
        """
        try:
            result = (
                text.replace("  ", "${SPACE}${SPACE}")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t")
            )
            # Escape leading/trailing spaces to prevent Robot Framework from
            # trimming them (RF strips leading/trailing whitespace from arguments)
            if result.startswith(" "):
                result = "${SPACE}" + result[1:]
            if result.endswith(" "):
                result = result[:-1] + "${SPACE}"
            return result
        except AttributeError:
            return text
