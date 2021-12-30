module alphabet_rom ( input [9:0] addr, output [7:0] data);

	parameter ROM_LENGTH = 16*37;
	parameter DATA_WIDTH = 8;

	// ROM definition				
	parameter [0:ROM_LENGTH-1][DATA_WIDTH-1:0] ROM = {	
		//code x00
		8'b00000000, // 0
        8'b00000000, // 1
        8'b00000000, // 2
        8'b00000000, // 3
        8'b00000000, // 4
        8'b00000000, // 5
        8'b00000000, // 6
        8'b00000000, // 7
        8'b00000000, // 8
        8'b00000000, // 9
        8'b00000000, // a
        8'b00000000, // b
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
		// code x01
        8'b00000000, // 0
        8'b00000000, // 1
        8'b00010000, // 2    *
        8'b00111000, // 3   ***
        8'b01101100, // 4  ** **
        8'b11000110, // 5 **   **
        8'b11000110, // 6 **   **
        8'b11111110, // 7 *******
        8'b11000110, // 8 **   **
        8'b11000110, // 9 **   **
        8'b11000110, // a **   **
        8'b11000110, // b **   **
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
         // code x02
        8'b00000000, // 0
        8'b00000000, // 1
        8'b11111100, // 2 ******
        8'b01100110, // 3  **  **
        8'b01100110, // 4  **  **
        8'b01100110, // 5  **  **
        8'b01111100, // 6  *****
        8'b01100110, // 7  **  **
        8'b01100110, // 8  **  **
        8'b01100110, // 9  **  **
        8'b01100110, // a  **  **
        8'b11111100, // b ******
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
         // code x03
        8'b00000000, // 0
        8'b00000000, // 1
        8'b00111100, // 2   ****
        8'b01100110, // 3  **  **
        8'b11000010, // 4 **    *
        8'b11000000, // 5 **
        8'b11000000, // 6 **
        8'b11000000, // 7 **
        8'b11000000, // 8 **
        8'b11000010, // 9 **    *
        8'b01100110, // a  **  **
        8'b00111100, // b   ****
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
         // code x04
        8'b00000000, // 0
        8'b00000000, // 1
        8'b11111000, // 2 *****
        8'b01101100, // 3  ** **
        8'b01100110, // 4  **  **
        8'b01100110, // 5  **  **
        8'b01100110, // 6  **  **
        8'b01100110, // 7  **  **
        8'b01100110, // 8  **  **
        8'b01100110, // 9  **  **
        8'b01101100, // a  ** **
        8'b11111000, // b *****
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
         // code x05
        8'b00000000, // 0
        8'b00000000, // 1
        8'b11111110, // 2 *******
        8'b01100110, // 3  **  **
        8'b01100010, // 4  **   *
        8'b01101000, // 5  ** *
        8'b01111000, // 6  ****
        8'b01101000, // 7  ** *
        8'b01100000, // 8  **
        8'b01100010, // 9  **   *
        8'b01100110, // a  **  **
        8'b11111110, // b *******
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
         // code x06
        8'b00000000, // 0
        8'b00000000, // 1
        8'b11111110, // 2 *******
        8'b01100110, // 3  **  **
        8'b01100010, // 4  **   *
        8'b01101000, // 5  ** *
        8'b01111000, // 6  ****
        8'b01101000, // 7  ** *
        8'b01100000, // 8  **
        8'b01100000, // 9  **
        8'b01100000, // a  **
        8'b11110000, // b ****
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
         // code x07
        8'b00000000, // 0
        8'b00000000, // 1
        8'b00111100, // 2   ****
        8'b01100110, // 3  **  **
        8'b11000010, // 4 **    *
        8'b11000000, // 5 **
        8'b11000000, // 6 **
        8'b11011110, // 7 ** ****
        8'b11000110, // 8 **   **
        8'b11000110, // 9 **   **
        8'b01100110, // a  **  **
        8'b00111010, // b   *** *
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
         // code x08
        8'b00000000, // 0
        8'b00000000, // 1
        8'b11000110, // 2 **   **
        8'b11000110, // 3 **   **
        8'b11000110, // 4 **   **
        8'b11000110, // 5 **   **
        8'b11111110, // 6 *******
        8'b11000110, // 7 **   **
        8'b11000110, // 8 **   **
        8'b11000110, // 9 **   **
        8'b11000110, // a **   **
        8'b11000110, // b **   **
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
         // code x09
        8'b00000000, // 0
        8'b00000000, // 1
        8'b00111100, // 2   ****
        8'b00011000, // 3    **
        8'b00011000, // 4    **
        8'b00011000, // 5    **
        8'b00011000, // 6    **
        8'b00011000, // 7    **
        8'b00011000, // 8    **
        8'b00011000, // 9    **
        8'b00011000, // a    **
        8'b00111100, // b   ****
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
         // code x0a
        8'b00000000, // 0
        8'b00000000, // 1
        8'b00011110, // 2    ****
        8'b00001100, // 3     **
        8'b00001100, // 4     **
        8'b00001100, // 5     **
        8'b00001100, // 6     **
        8'b00001100, // 7     **
        8'b11001100, // 8 **  **
        8'b11001100, // 9 **  **
        8'b11001100, // a **  **
        8'b01111000, // b  ****
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
         // code x0b
        8'b00000000, // 0
        8'b00000000, // 1
        8'b11100110, // 2 ***  **
        8'b01100110, // 3  **  **
        8'b01100110, // 4  **  **
        8'b01101100, // 5  ** **
        8'b01111000, // 6  ****
        8'b01111000, // 7  ****
        8'b01101100, // 8  ** **
        8'b01100110, // 9  **  **
        8'b01100110, // a  **  **
        8'b11100110, // b ***  **
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
         // code x0c
        8'b00000000, // 0
        8'b00000000, // 1
        8'b11110000, // 2 ****
        8'b01100000, // 3  **
        8'b01100000, // 4  **
        8'b01100000, // 5  **
        8'b01100000, // 6  **
        8'b01100000, // 7  **
        8'b01100000, // 8  **
        8'b01100010, // 9  **   *
        8'b01100110, // a  **  **
        8'b11111110, // b *******
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
         // code x0d
        8'b00000000, // 0
        8'b00000000, // 1
        8'b11000011, // 2 **    **
        8'b11100111, // 3 ***  ***
        8'b11111111, // 4 ********
        8'b11111111, // 5 ********
        8'b11011011, // 6 ** ** **
        8'b11000011, // 7 **    **
        8'b11000011, // 8 **    **
        8'b11000011, // 9 **    **
        8'b11000011, // a **    **
        8'b11000011, // b **    **
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
         // code x0e
        8'b00000000, // 0
        8'b00000000, // 1
        8'b11000110, // 2 **   **
        8'b11100110, // 3 ***  **
        8'b11110110, // 4 **** **
        8'b11111110, // 5 *******
        8'b11011110, // 6 ** ****
        8'b11001110, // 7 **  ***
        8'b11000110, // 8 **   **
        8'b11000110, // 9 **   **
        8'b11000110, // a **   **
        8'b11000110, // b **   **
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
         // code x0f
        8'b00000000, // 0
        8'b00000000, // 1
        8'b01111100, // 2  *****
        8'b11000110, // 3 **   **
        8'b11000110, // 4 **   **
        8'b11000110, // 5 **   **
        8'b11000110, // 6 **   **
        8'b11000110, // 7 **   **
        8'b11000110, // 8 **   **
        8'b11000110, // 9 **   **
        8'b11000110, // a **   **
        8'b01111100, // b  *****
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
         // code x10
        8'b00000000, // 0
        8'b00000000, // 1
        8'b11111100, // 2 ******
        8'b01100110, // 3  **  **
        8'b01100110, // 4  **  **
        8'b01100110, // 5  **  **
        8'b01111100, // 6  *****
        8'b01100000, // 7  **
        8'b01100000, // 8  **
        8'b01100000, // 9  **
        8'b01100000, // a  **
        8'b11110000, // b ****
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
         // code x11
        8'b00000000, // 0
        8'b00000000, // 1
        8'b01111100, // 2  *****
        8'b11000110, // 3 **   **
        8'b11000110, // 4 **   **
        8'b11000110, // 5 **   **
        8'b11000110, // 6 **   **
        8'b11000110, // 7 **   **
        8'b11000110, // 8 **   **
        8'b11010110, // 9 ** * **
        8'b11011110, // a ** ****
        8'b01111100, // b  *****
        8'b00001100, // c     **
        8'b00001110, // d     ***
        8'b00000000, // e
        8'b00000000, // f
         // code x12
        8'b00000000, // 0
        8'b00000000, // 1
        8'b11111100, // 2 ******
        8'b01100110, // 3  **  **
        8'b01100110, // 4  **  **
        8'b01100110, // 5  **  **
        8'b01111100, // 6  *****
        8'b01101100, // 7  ** **
        8'b01100110, // 8  **  **
        8'b01100110, // 9  **  **
        8'b01100110, // a  **  **
        8'b11100110, // b ***  **
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
         // code x13
        8'b00000000, // 0
        8'b00000000, // 1
        8'b01111100, // 2  *****
        8'b11000110, // 3 **   **
        8'b11000110, // 4 **   **
        8'b01100000, // 5  **
        8'b00111000, // 6   ***
        8'b00001100, // 7     **
        8'b00000110, // 8      **
        8'b11000110, // 9 **   **
        8'b11000110, // a **   **
        8'b01111100, // b  *****
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
         // code x14
        8'b00000000, // 0
        8'b00000000, // 1
        8'b11111111, // 2 ********
        8'b11011011, // 3 ** ** **
        8'b10011001, // 4 *  **  *
        8'b00011000, // 5    **
        8'b00011000, // 6    **
        8'b00011000, // 7    **
        8'b00011000, // 8    **
        8'b00011000, // 9    **
        8'b00011000, // a    **
        8'b00111100, // b   ****
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
         // code x15
        8'b00000000, // 0
        8'b00000000, // 1
        8'b11000110, // 2 **   **
        8'b11000110, // 3 **   **
        8'b11000110, // 4 **   **
        8'b11000110, // 5 **   **
        8'b11000110, // 6 **   **
        8'b11000110, // 7 **   **
        8'b11000110, // 8 **   **
        8'b11000110, // 9 **   **
        8'b11000110, // a **   **
        8'b01111100, // b  *****
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
         // code x16
        8'b00000000, // 0
        8'b00000000, // 1
        8'b11000011, // 2 **    **
        8'b11000011, // 3 **    **
        8'b11000011, // 4 **    **
        8'b11000011, // 5 **    **
        8'b11000011, // 6 **    **
        8'b11000011, // 7 **    **
        8'b11000011, // 8 **    **
        8'b01100110, // 9  **  **
        8'b00111100, // a   ****
        8'b00011000, // b    **
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
         // code x17
        8'b00000000, // 0
        8'b00000000, // 1
        8'b11000011, // 2 **    **
        8'b11000011, // 3 **    **
        8'b11000011, // 4 **    **
        8'b11000011, // 5 **    **
        8'b11000011, // 6 **    **
        8'b11011011, // 7 ** ** **
        8'b11011011, // 8 ** ** **
        8'b11111111, // 9 ********
        8'b01100110, // a  **  **
        8'b01100110, // b  **  **
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
        
         // code x18
        8'b00000000, // 0
        8'b00000000, // 1
        8'b11000011, // 2 **    **
        8'b11000011, // 3 **    **
        8'b01100110, // 4  **  **
        8'b00111100, // 5   ****
        8'b00011000, // 6    **
        8'b00011000, // 7    **
        8'b00111100, // 8   ****
        8'b01100110, // 9  **  **
        8'b11000011, // a **    **
        8'b11000011, // b **    **
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
         // code x19
        8'b00000000, // 0
        8'b00000000, // 1
        8'b11000011, // 2 **    **
        8'b11000011, // 3 **    **
        8'b11000011, // 4 **    **
        8'b01100110, // 5  **  **
        8'b00111100, // 6   ****
        8'b00011000, // 7    **
        8'b00011000, // 8    **
        8'b00011000, // 9    **
        8'b00011000, // a    **
        8'b00111100, // b   ****
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
         // code x1a
        8'b00000000, // 0
        8'b00000000, // 1
        8'b11111111, // 2 ********
        8'b11000011, // 3 **    **
        8'b10000110, // 4 *    **
        8'b00001100, // 5     **
        8'b00011000, // 6    **
        8'b00110000, // 7   **
        8'b01100000, // 8  **
        8'b11000001, // 9 **     *
        8'b11000011, // a **    **
        8'b11111111, // b ********
        8'b00000000, // c
        8'b00000000, // d
        8'b00000000, // e
        8'b00000000, // f
			// code x0
			8'b00000000, // 0
			8'b00000000, // 1
			8'b01111100, // 2  *****
			8'b11000110, // 3 **   **
			8'b11000110, // 4 **   **
			8'b11001110, // 5 **  ***
			8'b11011110, // 6 ** ****
			8'b11110110, // 7 **** **
			8'b11100110, // 8 ***  **
			8'b11000110, // 9 **   **
			8'b11000110, // a **   **
			8'b01111100, // b  *****
			8'b00000000, // c
			8'b00000000, // d
			8'b00000000, // e
			8'b00000000, // f
			// code x1
			8'b00000000, // 0
			8'b00000000, // 1
			8'b00011000, // 2
			8'b00111000, // 3
			8'b01111000, // 4    **
			8'b00011000, // 5   ***
			8'b00011000, // 6  ****
			8'b00011000, // 7    **
			8'b00011000, // 8    **
			8'b00011000, // 9    **
			8'b00011000, // a    **
			8'b01111110, // b    **
			8'b00000000, // c    **
			8'b00000000, // d  ******
			8'b00000000, // e
			8'b00000000, // f
			// code x2
			8'b00000000, // 0
			8'b00000000, // 1
			8'b01111100, // 2  *****
			8'b11000110, // 3 **   **
			8'b00000110, // 4      **
			8'b00001100, // 5     **
			8'b00011000, // 6    **
			8'b00110000, // 7   **
			8'b01100000, // 8  **
			8'b11000000, // 9 **
			8'b11000110, // a **   **
			8'b11111110, // b *******
			8'b00000000, // c
			8'b00000000, // d
			8'b00000000, // e
			8'b00000000, // f
			// code x3
			8'b00000000, // 0
			8'b00000000, // 1
			8'b01111100, // 2  *****
			8'b11000110, // 3 **   **
			8'b00000110, // 4      **
			8'b00000110, // 5      **
			8'b00111100, // 6   ****
			8'b00000110, // 7      **
			8'b00000110, // 8      **
			8'b00000110, // 9      **
			8'b11000110, // a **   **
			8'b01111100, // b  *****
			8'b00000000, // c
			8'b00000000, // d
			8'b00000000, // e
			8'b00000000, // f
			// code x4
			8'b00000000, // 0
			8'b00000000, // 1
			8'b00001100, // 2     **
			8'b00011100, // 3    ***
			8'b00111100, // 4   ****
			8'b01101100, // 5  ** **
			8'b11001100, // 6 **  **
			8'b11111110, // 7 *******
			8'b00001100, // 8     **
			8'b00001100, // 9     **
			8'b00001100, // a     **
			8'b00011110, // b    ****
			8'b00000000, // c
			8'b00000000, // d
			8'b00000000, // e
			8'b00000000, // f
			// code x5
			8'b00000000, // 0
			8'b00000000, // 1
			8'b11111110, // 2 *******
			8'b11000000, // 3 **
			8'b11000000, // 4 **
			8'b11000000, // 5 **
			8'b11111100, // 6 ******
			8'b00000110, // 7      **
			8'b00000110, // 8      **
			8'b00000110, // 9      **
			8'b11000110, // a **   **
			8'b01111100, // b  *****
			8'b00000000, // c
			8'b00000000, // d
			8'b00000000, // e
			8'b00000000, // f
			// code x6
			8'b00000000, // 0
			8'b00000000, // 1
			8'b00111000, // 2   ***
			8'b01100000, // 3  **
			8'b11000000, // 4 **
			8'b11000000, // 5 **
			8'b11111100, // 6 ******
			8'b11000110, // 7 **   **
			8'b11000110, // 8 **   **
			8'b11000110, // 9 **   **
			8'b11000110, // a **   **
			8'b01111100, // b  *****
			8'b00000000, // c
			8'b00000000, // d
			8'b00000000, // e
			8'b00000000, // f
			// code x7
			8'b00000000, // 0
			8'b00000000, // 1
			8'b11111110, // 2 *******
			8'b11000110, // 3 **   **
			8'b00000110, // 4      **
			8'b00000110, // 5      **
			8'b00001100, // 6     **
			8'b00011000, // 7    **
			8'b00110000, // 8   **
			8'b00110000, // 9   **
			8'b00110000, // a   **
			8'b00110000, // b   **
			8'b00000000, // c
			8'b00000000, // d
			8'b00000000, // e
			8'b00000000, // f
			// code x8
			8'b00000000, // 0
			8'b00000000, // 1
			8'b01111100, // 2  *****
			8'b11000110, // 3 **   **
			8'b11000110, // 4 **   **
			8'b11000110, // 5 **   **
			8'b01111100, // 6  *****
			8'b11000110, // 7 **   **
			8'b11000110, // 8 **   **
			8'b11000110, // 9 **   **
			8'b11000110, // a **   **
			8'b01111100, // b  *****
			8'b00000000, // c
			8'b00000000, // d
			8'b00000000, // e
			8'b00000000, // f
			// code x9
			8'b00000000, // 0
			8'b00000000, // 1
			8'b01111100, // 2  *****
			8'b11000110, // 3 **   **
			8'b11000110, // 4 **   **
			8'b11000110, // 5 **   **
			8'b01111110, // 6  ******
			8'b00000110, // 7      **
			8'b00000110, // 8      **
			8'b00000110, // 9      **
			8'b00001100, // a     **
			8'b01111000, // b  ****
			8'b00000000, // c
			8'b00000000, // d
			8'b00000000, // e
			8'b00000000 // f
};

	assign data = ROM[addr];

endmodule  

