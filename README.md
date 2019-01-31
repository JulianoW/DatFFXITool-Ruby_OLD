# DatFFXITool
FFXI Dat File Manager - Extract and Re-Package

To Do List:

1. Create a separate file for Encryption/Decoding

- Move Integer rotate() method - DONE
- Rename to ror, create a rol - DONE
- Need to create something to translate special characters (auto-trans brackets, element icons, probably more...)
- - These are byte pairs starting with 0xEF - Try and see what all values there are? Might be more than just elements available?
- - Side-note, see SHIFT-JIS hex values here https://github.com/google/mozc/blob/master/src/data/unicode/SHIFTJIS.TXT for use in strings, format "\xF0\x0D"

2. Possible additions to BinData

- ??? (May need some changes/additions to string? see #7)

3. Complete Graphics portion for armor prototype - DONE

- Need to finish researching DAT format to extract the graphic portion of items - DONE

4. Refactor BinData::Records for reusability and DRYness, with other item types in mind
- Header, Graphic portions should be reusable - DONE
- Think of a way to simplify string section - DONE...ish

5. Save output in a useful & workable format
- What would be the most useful way for end users to make modifications?
- Thinking a database would be good for mass changes
- JSON would also be good for small one off changes
- Need to do more research and think about this some more...

6. Load output (json, db?? see #5) to rebuild custom DAT's
- Read in output format, assign to BinData::Records, use .to_binary_s to convert to binary, rotate back & build the .DAT file

7. Handle String Sizes
- Two Options:
  - Change all offsets to allow for larger names (should be more than enough space to fit the longest of descriptions) -- test and make sure client accepts this and doesn't break? - DID NOT DO THIS.
  - Compare current string size (check :length on the strings) and see if the input fits, if not, adjust offsets to accomodate before assigning (would cause a mismatch between what gets written as an offset and what is being passed in, though... but in that case those wouldn't need to be maintained anyway, could probably not write them and just always calculate on the upload?) 
  - - PARTIALLY DONE: Dynamically resizes string length up, need to make it also resize down

8. Use FFXI directory to grab files, maybe just for initialization? Move to working directory?

9. Organize output dat files

10. Set up input arguments, or a prompt, to do various things (main program logic)

11. Re-use work to add support for more dat's
