#HAPPY 303
use_debug false
use_bpm 155
#----------------------------------------------------------------------
#MIXER
master = 1.0

kick_amp = 1.2

tüt1_amp = 0.4
tüt2_amp = 0.4

clap_amp = 0.7
railride_amp = 0.15
ride_amp = 0.4

synth1_amp = 0.5
synth2_amp = 0.3

#----------------------------------------------------------------------
#RHYTHMS
kick_rhythm = (ring 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
               1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1,
               1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
               1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 0, 0, 1)


sn_rhythm = (ring 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
             1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1,
             1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
             1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 1,1)

#----------------------------------------------------------------------
#SAMPLES
kick = "*your path*/happy303/samples/kick.wav"
snare = "*your path*/happy303/samples/snare.wav"
hat = "*your path*/happy303/samples/hats.wav"
clap = "*your path*/happy303/samples/clap.wav"
#----------------------------------------------------------------------

#DRUMS
live_loop :kick do
  #stop
  with_fx :gverb, release: 0.025, dry: 0.75, room: 2.3 do # 2.2
    with_fx :eq, low_shelf: 0.1,  low: 0.05 do
      sample kick, amp: kick_amp * master * kick_rhythm.tick, beat_stretch: 1.25, cutoff: 90, release: 0.1   , attack: 0.05
      sleep 0.5
    end
  end
end

live_loop :tüt1 do
  #stop
  with_fx :reverb, mix: 0.5, room: 0.75 do
    #with_fx :ping_pong, feedback: 0.55 do #:slicer, phase: 0.5 | :ping_pong, feedback: 0.55
    sample snare, #openhat | snare
      amp: tüt1_amp * master,
      beat_stretch: (ring 1.0, 1.075).tick,
      cutoff: 90
    sleep 4
    #end
  end
end


live_loop :tüt2 do
  #stop
  with_fx :reverb, mix: 0.15, room: 0.2 do
    sample snare, #openhat | snare | drum
      amp: tüt2_amp * master,
      beat_stretch: 1,
      rate: (ring  2, -1).tick,
      cutoff: 90
    sleep 4
  end
end

live_loop :clap do
  #stop
  with_fx :reverb, mix: 0.5, room: 0.5 do
    sample clap,
      amp: clap_amp * master * sn_rhythm.tick ,
      beat_stretch: 0.5,
      cutoff: 90,
      rate: 1
    sleep 1
  end
end

live_loop :ride do
  #stop
  with_fx :reverb, mix: 0.5, room: 0.25 do
    ride_co = range(105, 100, 1).mirror
    with_fx :reverb, mix: 0.3, room: 0.25 do
      sample  hat,
        amp: ride_amp * master * sn_rhythm.tick,
        beat_stretch: 1,
        cutoff: ride_co.look,
        rate: 3
      sleep 0.5
    end
  end
end

live_loop :railride do
  #stop
  with_fx :reverb, mix: 0.25 do
    sample  hat,
      amp: railride_amp * master,
      rate: -1.75,
      cutoff: 120,
      release: 0.08,
      attack: 0.01
    sleep 1
  end
end

#SYNTHS
live_loop :synth1 do
  #stop
  with_fx :reverb do
    with_fx :slicer, phase: 0.5 do
      use_random_seed (ring, 2000, 22).tick
      4.times do
        with_synth :bass_foundation do
          n = (ring :d3, :f2, :e3, :b3).choose
          play scale(n, :blues_major).choose,
            release: (ring 6, 6.5, 7,  6).tick ,
            cutoff: 100,
            res: 0.6,
            attack: 0.001,
            wave: 1,
            amp: synth2_amp * master,
            pitch: 8 #
          sleep 4
        end
      end
    end
  end
end

live_loop :happy_303 do
  #stop
  with_fx :reverb, mix: 0.35, room: 0.25 do
    with_fx :hpf, cutoff: 20 do
      with_fx :lpf, cutoff: 130 do
        use_random_seed (ring, 2000, 22).tick #(ring, 20, 22).tick | (ring, 2000, 22).tick
        2.times do # 16 | 2
          with_synth :bass_foundation do
            synth_co = range(80, 90, 1).mirror
            n = (ring :d2, :f2, :e3, :b3).choose
            play scale(n, :bartok).choose,
              release: (ring 0.01, 7.5, 9, 7).tick  , # 0.01, 7.5, 9, 7 || 0.5, 0.75, 0.9, 0.25 || 0.01, 2.0, 2.5, 1.75
              cutoff: synth_co.look,
              res: 0.8,
              attack: 0.001,
              amp: synth1_amp * master, #
              pitch: -10 # -7 || -10,
              sleep 2 # 0.5 | 2
          end
        end
      end
    end
  end
end