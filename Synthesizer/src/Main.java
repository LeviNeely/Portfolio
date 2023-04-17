package com.example.synthesizer;
import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.Clip;
import javax.sound.sampled.LineUnavailableException;
import java.util.ArrayList;

public class Main {
    public static void main(String[] args) throws LineUnavailableException {
//        AudioClip test = new AudioClip();
//        test.setSample(5, 45);
//        test.setSample(0, -55);
//        test.setSample(88199, 120);
//        test.setSample(176400, -1000000000);
//        test.setSample(-1, 1000000000);
//        System.out.println(test.getSample(5));
//        System.out.println(test.getSample(0));
//        System.out.println(test.getSample(88199));
//        System.out.println(test.getSample(176400));
//        System.out.println(test.getSample(-1));
//        SineWave test = new SineWave(440);
//        AudioClip wave = test.getClip();
//        for (int i = 0; i < 88200; i++){
//            System.out.println(wave.getSample(i));
//        }

//        AudioClip test = new AudioClip();
//
//        for( Short s = Short.MIN_VALUE; s < Short.MAX_VALUE; s++ ) {
//            test.setSample( 0, s );
//            int out = test.getSample( 0 );
//            if( s != out ) {
//                System.out.println("ERROR for " + s);
//                break;
//            }
//        }

        Clip c = AudioSystem.getClip();
        AudioFormat format16 = new AudioFormat( 44100, 16, 1, true, false );

//      Sine wave testing:
//        AudioComponent sw = new SineWave(0);
//        AudioComponent sw = new SineWave(-440);
//        AudioComponent sw = new SineWave(440);
//        AudioClip clip = sw.getClip();
//        c.open( format16, clip.getData(), 0, clip.getData().length);
//        System.out.println("About to play...");
//        c.start();
//        //c.loop(2);
//        while (c.getFramePosition() < AudioClip.TOTAL_SAMPLES || c.isActive() || c.isRunning()){
//        }
//        System.out.println("Done.");

//      VolumeAdjuster testing:
//        AudioComponent sw = new SineWave(440);
//        AudioComponent va = new VolumeAdjuster(-5);
//        AudioComponent va = new VolumeAdjuster(2);
//        AudioComponent va = new VolumeAdjuster(1);
//        AudioComponent va = new VolumeAdjuster(0.8);
//        va.connectInput(sw);
//        AudioClip clip = va.getClip();
//        c.open( format16, clip.getData(), 0, clip.getData().length);
//        System.out.println("About to play...");
//        c.start();
//        //c.loop(2);
//        while (c.getFramePosition() < AudioClip.TOTAL_SAMPLES || c.isActive() || c.isRunning()){
//        }
//        System.out.println("Done.");

//      Mixer testing:
//        AudioComponent sw = new SineWave(90);
//        AudioComponent sw2 = new SineWave(66);
//        AudioComponent sw3 = new SineWave(22);
//        AudioComponent sw4 = new SineWave(44);
//        AudioComponent va = new VolumeAdjuster(0.5);
//        AudioComponent va2 = new VolumeAdjuster(0.5);
//        AudioComponent va3 = new VolumeAdjuster(0.5);
//        AudioComponent va4 = new VolumeAdjuster(0.5);
//        va.connectInput(sw);
//        va2.connectInput(sw2);
//        va3.connectInput(sw3);
//        va4.connectInput(sw4);
//        AudioComponent mixer = new Mixer();
//        mixer.connectInput(sw);
//        mixer.connectInput(sw2);
//        mixer.connectInput(sw3);
//        mixer.connectInput(sw4);
//        AudioClip clip = mixer.getClip();
//        c.open( format16, clip.getData(), 0, clip.getData().length);
//        System.out.println("About to play...");
//        c.start();
//        //c.loop(2);
//        while (c.getFramePosition() < AudioClip.TOTAL_SAMPLES || c.isActive() || c.isRunning()){
//        }
//        System.out.println("Done.");

//      Square Wave testing:
//        AudioComponent sw = new SineWave(440);
//        AudioComponent va = new VolumeAdjuster(1);
//        va.connectInput(sw);
//        AudioComponent sqw = new SquareWave();
//        sqw.connectInput(va);
//        AudioClip clip = sqw.getClip();
//        c.open( format16, clip.getData(), 0, clip.getData().length);
//        System.out.println("About to play...");
//        c.start();
//        //c.loop(2);
//        while (c.getFramePosition() < AudioClip.TOTAL_SAMPLES || c.isActive() || c.isRunning()){
//        }
//        System.out.println("Done.");

//      LinearRamp and VFWaveGenerator testing:
//        AudioComponent lr = new LinearRamp(-5, 5000);
//        AudioComponent lr = new LinearRamp(5000, 50);
//        AudioComponent lr = new LinearRamp(50, 2000);
//        AudioComponent vfwg = new VFWaveGenerator();
//        vfwg.connectInput(lr);
//        AudioClip clip = vfwg.getClip();
//        c.open( format16, clip.getData(), 0, clip.getData().length);
//        System.out.println("About to play...");
//        c.start();
//        //c.loop(2);
//        while (c.getFramePosition() < AudioClip.TOTAL_SAMPLES || c.isActive() || c.isRunning()){
//        }
//        System.out.println("Done.");
    }
}


