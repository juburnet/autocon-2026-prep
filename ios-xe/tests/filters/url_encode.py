# Copyright: (c) 2025, Daniel Schmidt <danischm@cisco.com>
from urllib.parse import quote_plus


class Filter:
    name = "url_encode"

    @classmethod
    def filter(cls, text):
        """url encodes a string with characters in order to make them safe for restconf

        Example: converts "/" to "%2F" to make them not break the restconf uri.

        Args:
            text: The string to url encode. If not a string, returns unchanged.

        Returns:
            str: The url encoded string.
        """
        try:
            return quote_plus(str(text))
        except AttributeError:
            return text
