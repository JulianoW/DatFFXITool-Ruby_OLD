# Not putting in a module, want to extend Integer so don't have to constantly call FFXI_ENCRYPTION::

class Integer

    #rotate right n bits (8 bits/1 byte)
    def ror(n)
        (self >> n | self << (8 - n) ) % 256
    end
    
    #rotate left n bits (8 bits/1 byte)
    def rol(n)
        (self << n | self >> (8 - n) ) % 256
    end

    # Blue in FFXI RGBA color scheme format
    def blue()
        (self & 0xff000000) >> 24
    end

    # Green in FFXI RGBA color scheme format
    def green()
        (self & 0x00ff0000) >> 16
    end

    # Red in FFXI RGBA color scheme format
    def red()
        (self & 0x0000ff00) >> 8
    end

    # Alpha in FFXI RGBA color scheme format
    # Is this used anywhere?
    #def alpha()
    #    self & 0x000000ff
    #end

    # SemiAlpha in FFXI RGBA color scheme format
    # DATs store alpha values in "semialpha", for whatever reason.
    # This returns the semialpha as the full alpha value, for use in chunky_png
    def semialpha()
        alpha = 255
        semialpha = self & 0x000000ff
        # if less than 0x80, multuiply by 2, otherwise, 255 (0xFF)
        if (semialpha < 0x80) then
            alpha = 2 * semialpha
        end
        alpha
    end

    # SemiAlpha in FFXI RGBA color scheme format
    # Takes the alpha value in a RGBA format, such as the one from chunky_png
    # and divides it by 2 to match FFXI's "semialpha"
    def to_semialpha()
        alpha = self & 0x000000ff
        semialpha = (alpha / 2.0).ceil
        semialpha
    end
end