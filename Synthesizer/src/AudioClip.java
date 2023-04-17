package com.example.synthesizer;
import java.util.Arrays;

public class AudioClip {
    static final double duration = 2.0;
    public static final int sampleRate = 44100;
    public static final int TOTAL_SAMPLES = (int)duration*sampleRate;
    byte[] data = new byte[TOTAL_SAMPLES*2];
    public int getSample (int index){
        int num1 = data[(index*2)+1];
//      Since the data is split in two pieces, we have to make sure it is
//      changed into an unsigned int, eliminating any negative values that might be given.
        int num2 = Byte.toUnsignedInt(data[(index*2)]);
        num1 = num1 << 8;
        num1 = (num1 | num2);
        return num1;
    }
    public void setSample (int index, int value){
        if (value > Short.MAX_VALUE){
            value = Short.MAX_VALUE;
        }
        else if (value < Short.MIN_VALUE){
            value = Short.MIN_VALUE;
        }
        int num1 = 0;
        int num2 = 0;
        num1 = value >> 8;
        num2 = value;
        data[index*2] = (byte) num2;
        data[(index*2)+1] = (byte) num1;
    }
    public byte[] getData (){
        byte[] copy = Arrays.copyOf(data, 176400);
        return copy;
    }

}
