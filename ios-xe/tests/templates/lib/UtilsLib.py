# Copyright: (c) 2025, Daniel Schmidt <danischm@cisco.com>

from robot.api.deco import keyword
import re

__version__ = "0.1.0"


class UtilsLib(object):
    ROBOT_LIBRARY_VERSION = __version__
    ROBOT_LIBRARY_SCOPE = "GLOBAL"

    @keyword("Normalize String")
    def normalize_string(self, text):
        try:
            if isinstance(text, list):
                if len(text) == 0:
                    return ""
                text = text[0]
            text = str(text)
            if re.search(r"(\\n|\\t|\\r|  |\\x0[d,D]|\\x0[a,A]|\\x09)", text):
                return (
                    text.replace("\\n", "\n")
                    .replace("\\r", "\r")
                    .replace("\\t", "\t")
                    .replace("  ", "${SPACE}${SPACE}")
                    .replace("\\x0d", "\r")
                    .replace("\\x0a", "\n")
                    .replace("\\x09", "\t")
                )
            else:
                return text
        except AttributeError:
            return text
