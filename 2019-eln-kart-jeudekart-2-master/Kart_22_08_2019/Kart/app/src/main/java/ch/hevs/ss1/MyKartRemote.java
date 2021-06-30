package ch.hevs.ss1;
import android.graphics.Color;
import android.content.res.ColorStateList;
import android.os.Bundle;
import ch.hevs.kart.AbstractKartControlActivity;
import android.view.View;
import android.view.Window;
import android.view.MotionEvent;
import android.view.KeyEvent;
import java.util.ArrayList;
import android.view.InputDevice;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.ToggleButton;
import android.widget.SeekBar;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.hardware.SensorManager;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.content.Context;
import android.widget.CompoundButton;
import ch.hevs.kart.Kart;
import ch.hevs.kart.KartHardwareSettings;
import ch.hevs.kart.KartStatusRegister;
import ch.hevs.kart.KartStatusRegisterListener;
import ch.hevs.kart.utils.Timer;

public class MyKartRemote extends AbstractKartControlActivity implements View.OnClickListener, SeekBar.OnSeekBarChangeListener, SensorEventListener{
    // constant
    private final int MAX_STEERING_POS = 1380; //1380

    // UI
    SeekBar speed;
    SeekBar direction;
    ProgressBar battery;
    ProgressBar steeringPos;
    ToggleButton accelerometer;
    ToggleButton gameremote;
    ToggleButton roof;
    TextView speedCounter;
    TextView pourcentBattery;
    TextView sterringPosition;
    TextView hall1;
    TextView state;
    TextView ultrason;
    ImageView batWheel;
    Button setup;

    // variables
    private SensorManager senSensorManager;
    private Sensor senAccelerometer;
    private long lastUpdate = 0;
    private float last_x, last_y, last_z;
    private static final int SHAKE_THRESHOLD = 600;
    private boolean accelerometerON = false;
    private boolean remote = false;
    private int hallsensor = 0;
    private int hallsensorLast = 0;
    private int counterTimer = 0;
    private int lastSpeed = 0;
    private int remoteSpeedPos = 0;
    private int accelerometerSteeringPos = 0;

    Timer timerStatus;
    Timer timerLed;

    boolean keyUpRoof = false;
    boolean flipflopRoof = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        this.requestFullscreen();
        setContentView(R.layout.activity_my_kart_remote);
        kart.setup()
                .drivePwmPeriod(80)
                .steeringStepPeriod(80);//120

        //kart setup
        //kart.setup().setHwSetting(KartHardwareSettings.InverseSteeringEndContactPosition);
        kart.setup().setHwSetting(KartHardwareSettings.InverseSteeringDirection);
        kart.setup().steeringMaxPosition(MAX_STEERING_POS);

        //setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
        senSensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
        senAccelerometer = senSensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
        senSensorManager.registerListener(this, senAccelerometer , SensorManager.SENSOR_DELAY_NORMAL);
        speed = findViewById(R.id.seekBar3);
        direction = findViewById(R.id.seekBar);
        battery = findViewById(R.id.progressBar);
        steeringPos = findViewById(R.id.progressBar2);
        speedCounter = findViewById(R.id.textView3);
        pourcentBattery = findViewById(R.id.textView4);
        sterringPosition = findViewById(R.id.textView15);
        accelerometer = findViewById(R.id.toggleButton);
        gameremote = findViewById(R.id.toggleButton2);
        roof = findViewById(R.id.toggleButton3);
        batWheel = findViewById(R.id.batwheel);
        setup = findViewById(R.id.button);
        hall1 = findViewById(R.id.textView17);
        state = findViewById(R.id.textView21);
        ultrason = findViewById(R.id.textView22);

        // listener
        setup.setOnClickListener(this);
        accelerometer.setOnClickListener(this);
        gameremote.setOnClickListener(this);
        speed.setOnSeekBarChangeListener(this);
        direction.setOnSeekBarChangeListener(this);

        //init steering seekbar max
        direction.setMax(MAX_STEERING_POS);
        direction.setProgress(MAX_STEERING_POS/2);
        steeringPos.setMax(MAX_STEERING_POS);

        hall1.setVisibility(TextView.INVISIBLE);


        // status register event
        kart.addStatusRegisterListener(new KartStatusRegisterListener() {
            @Override
            public void statusRegisterHasChanged(Kart kart, KartStatusRegister kartStatusRegister, int i) {
                if (kartStatusRegister.getAddress() == 0) {
                    hall1.setText(""+i);
                }
                else if (kartStatusRegister.getAddress() == 1) {
                    //hall2.setText(""+i);
                }
                else if (kartStatusRegister.getAddress() == 6) {
                    //ultrason.setText((double)(i)+"cm");
                }
            }
        });

        // accelerometer button event
        accelerometer.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (isChecked) {
                    // The toggle is enabled
                    accelerometerON = true;
                    direction.setEnabled(false);
                    gameremote.setEnabled(false);
                } else {
                    // The toggle is disabled
                    accelerometerON = false;
                    direction.setEnabled(true);
                    gameremote.setEnabled(true);
                    kart.setSteeringPosition(MAX_STEERING_POS/2);
                }
            }
        });

        // remote button event
        gameremote.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (isChecked) {
                    remote = true;
                    direction.setEnabled(false);
                    speed.setEnabled(false);
                    accelerometer.setEnabled(false);
                }else {
                    // The toggle is disabled
                    remote = false;
                    direction.setEnabled(true);
                    speed.setEnabled(true);
                    accelerometer.setEnabled(true);
                    kart.setSteeringPosition(MAX_STEERING_POS/2);
                    kart.setDriveSpeed(0);

                }
            }
        });

        // timer status event
        timerStatus  = new Timer() {
            @Override
            public void onTimeout() {
                hallsensor = kart.getStatusRegisterUnsigned(KartStatusRegister.HallSensorCounter1);
                ultrason.setText(kart.getStatusRegisterUnsigned(KartStatusRegister.DistanceSensor)*0.0017+"cm");
                if(hallsensor != hallsensorLast){
                    double val = ((double)(hallsensor-hallsensorLast))*0.3031636911/(counterTimer*0.001);
                    if(val < 20.0){
                        speedCounter.setText(String.format("%.1f km/h",val,counterTimer));
                    }

                    counterTimer = 1;
                    hallsensorLast = hallsensor;
                }
                else{
                    counterTimer++;
                    if(counterTimer >= 1000){
                        counterTimer = 1;
                        speedCounter.setText("0 km/h");
                    }
                }
            }
        };

        // timer led controller
        timerLed = new Timer() {
            @Override
            public void onTimeout() {
                int progress;

                if(remote == true){
                    progress = remoteSpeedPos;
                }
                else{
                    progress = speed.getProgress();
                }


                //freinage detection
                if ((lastSpeed > 0 && lastSpeed > progress) || (lastSpeed < 0 && lastSpeed < progress)){
                    //LED FREINAGE = 1;
                    kart.setLed(2,false);
                }
                else{
                    //LED FREINAGE = 0;
                    kart.setLed(2,true);
                }

                // propuls detection
                if ((progress > 10) || (lastSpeed > 0 && lastSpeed < progress)){
                    //LED PROPULS = 1;
                    kart.setLed(3,false);
                }
                else{
                    //LED PROPULS = 0;
                    kart.setLed(3,true);
                }

                //mode detection
                if (progress >= 0){
                    //mode normal
                    kart.setLed(0,true);
                    kart.setLed(1,true);
                }
                else{
                    //mode backward
                    kart.setLed(0,true);
                    kart.setLed(1,false);
                }

                lastSpeed = progress;
            }
        };

        // roof button event
        roof.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton compoundButton, boolean isChecked) {
                if (isChecked) {
                    timerLed.stop();

                    //mode opening
                    kart.setLed(0,false);
                    kart.setLed(1,false);
                }else {
                    //mode normal
                    kart.setLed(0,true);
                    kart.setLed(1,true);

                    timerLed.schedulePeriodically(300);
                }
            }
        });

        timerStatus.schedulePeriodically(1);
        timerLed.schedulePeriodically(300);

    }

    @Override
    public void onClick (View v){

        if(v == setup){
            // kart setup
            showKartSetupPopup();
        }
    }
    @Override
    public void onProgressChanged (SeekBar seekBar, int progress, boolean fromUser){
        if (seekBar == speed){
            kart.setDriveSpeed(progress);
                //speedCounter.setText(Integer.toString(progress));
        }
        if(accelerometerON == false) {
            if (seekBar == direction) {
                kart.setSteeringPosition(progress);
            }
        }
    }
    @Override
    public void onStartTrackingTouch (SeekBar seekBar) { }
    @Override
    public void onStopTrackingTouch (SeekBar seekBar) {

        if (seekBar == direction) {
                direction.setProgress(MAX_STEERING_POS/2);
        }
        if(seekBar == speed){
            speed.setProgress(0);
        }
    }
    @Override
    protected void onPause(){
        super.onPause();
        if(accelerometerON == true) {
            senSensorManager.unregisterListener(this);
        }
        timerLed.stop();
        timerStatus.stop();

    }
    @Override
    protected void onResume(){
        super.onResume();
        if(accelerometerON == true){
            senSensorManager.registerListener(this, senAccelerometer, SensorManager.SENSOR_DELAY_NORMAL);
        }
        timerStatus.schedulePeriodically(1);
        timerLed.schedulePeriodically(300);
    }
    @Override
    public void steeringPositionChanged(Kart kart, int i, float v) {
        steeringPos.setProgress(i);
            if (i >= 0 && i < MAX_STEERING_POS/2) {
                sterringPosition.setText("Left");
            } else if (i == MAX_STEERING_POS/2) {
                sterringPosition.setText("Straight");
            } else {
                sterringPosition.setText("Right");
            }
            batWheel.setRotation(v*20);
    }
    @Override
    public void steeringPositionReachedChanged(Kart kart, boolean b) { }
    @Override
    public void batteryVoltageChanged(Kart kart, float v) {
        battery.setProgress((int)(v*100.0));
        pourcentBattery.setText(Integer.toString((int)(v*100))+"%");
        float[] ColorBattery = {v*120,(float)1.0,(float)1.0};
        battery.setProgressTintList(ColorStateList.valueOf(Color.HSVToColor(ColorBattery)));

    }
    @Override
    public void sequenceCompleted(Kart kart) { }
    @Override
    public void connectionStatusChanged(Kart kart, boolean b) {
        if (b == true ){
            state.setText("online");
        }
        else{
            state.setText("offline");
        }
    }
    @Override
    public void message(Kart kart, String s) { }
    @Override
    public void onSensorChanged(SensorEvent sensorEvent) {
        Sensor mySensor = sensorEvent.sensor;
        if(accelerometerON == true) {

            if (mySensor.getType() == Sensor.TYPE_ACCELEROMETER) {
                float x = sensorEvent.values[0];
                float y = sensorEvent.values[1];
                float z = sensorEvent.values[2];

                long curTime = System.currentTimeMillis();

                if ((curTime - lastUpdate) > 100) {
                    long diffTime = (curTime - lastUpdate);
                    lastUpdate = curTime;

                    float speed = Math.abs(x + y + z - last_x - last_y - last_z) / diffTime * 10000;

                    if (speed > SHAKE_THRESHOLD) {
                    }
                    last_x = x;
                    last_y = y;
                    last_z = z;
                }
            }
            kart.setSteeringPosition((int)(last_y*MAX_STEERING_POS/10.0 + MAX_STEERING_POS/2.0));
            accelerometerSteeringPos = (int)(last_y*MAX_STEERING_POS/10.0 + MAX_STEERING_POS/2.0);
        }
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int accuracy) { }

    //pour si on veut plus d'1 manette
    public ArrayList<Integer> getGameControllerIds() {
        ArrayList<Integer> gameControllerDeviceIds = new ArrayList<Integer>();
        int[] deviceIds = InputDevice.getDeviceIds();
        for (int deviceId : deviceIds) {
            InputDevice dev = InputDevice.getDevice(deviceId);
            int sources = dev.getSources();

            // Verify that the device has gamepad buttons, control sticks, or both.
            if (((sources & InputDevice.SOURCE_GAMEPAD) == InputDevice.SOURCE_GAMEPAD)
                    || ((sources & InputDevice.SOURCE_JOYSTICK)
                    == InputDevice.SOURCE_JOYSTICK)) {
                // This device is a game controller. Store its device ID.
                if (!gameControllerDeviceIds.contains(deviceId)) {
                    gameControllerDeviceIds.add(deviceId);
                }
            }
        }
        return gameControllerDeviceIds;
    }

    //gere bouton de la manette
    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        boolean handled = false;
        if ((event.getSource() & InputDevice.SOURCE_GAMEPAD)
                == InputDevice.SOURCE_GAMEPAD) {
            if (event.getRepeatCount() == 0) {
                switch (keyCode) {
                    // Handle gamepad and D-pad button presses to
                    // navigate the ship
                    case KeyEvent.KEYCODE_BUTTON_A:
                        if(KeyEvent.ACTION_DOWN == event.getAction()){
                           if(flipflopRoof == false){
                               roof.setChecked(true);
                               flipflopRoof = true;
                           }
                           else{
                               roof.setChecked(false);
                               flipflopRoof = false;
                           }
                        }
                        break;
                    default:

                        break;
                }
            }
            if (handled) {
                return true;
            }
        }
        return true /*super.onKeyDown(keyCode, event)*/;
    }

    //gere joystick + R2 +L2 et les eventement liés
    @Override
    public boolean onGenericMotionEvent(MotionEvent event) {

        // Check that the event came from a game controller
        if ((event.getSource() & InputDevice.SOURCE_JOYSTICK) ==
                InputDevice.SOURCE_JOYSTICK &&
                event.getAction() == MotionEvent.ACTION_MOVE) {

            // Process all historical movement samples in the batch
            final int historySize = event.getHistorySize();

            // Process the movements starting from the
            // earliest historical position in the batch
            for (int i = 0; i < historySize; i++) {
                // Process the event at historical position i
                processJoystickInput(event, i);
            }
            processTriggerInput(event);
            // Process the current movement sample in the batch (position -1)
            processJoystickInput(event, -1);
            return true;
        }

        return super.onGenericMotionEvent(event);
    }
        private void processJoystickInput(MotionEvent event, int historyPos) {

            InputDevice inputDevice = event.getDevice();

            // Calculate the horizontal distance to move by
            // using the input value from one of these physical controls:
            // the left control stick, hat axis, or the right control stick.
            float x = getCenteredAxis(event, inputDevice,
                    MotionEvent.AXIS_X, historyPos);
            if (x == 0) {
                x = getCenteredAxis(event, inputDevice,
                        MotionEvent.AXIS_HAT_X, historyPos);
            }
            if (x == 0) {
                x = getCenteredAxis(event, inputDevice,
                        MotionEvent.AXIS_Z, historyPos);
            }

            // Calculate the vertical distance to move by
            // using the input value from one of these physical controls:
            // the left control stick, hat switch, or the right control stick.
            float y = getCenteredAxis(event, inputDevice,
                    MotionEvent.AXIS_Y, historyPos);
            if (y == 0) {
                y = getCenteredAxis(event, inputDevice,
                        MotionEvent.AXIS_HAT_Y, historyPos);
            }
            if (y == 0) {
                y = getCenteredAxis(event, inputDevice,
                        MotionEvent.AXIS_RZ, historyPos);
            }

            // Update the ship object based on the new x and y values
           if(remote == true){
               kart.setSteeringPosition((int)(x*MAX_STEERING_POS/2.0 +MAX_STEERING_POS/2.0));
           }

        }
    private static float getCenteredAxis(MotionEvent event,
                                         InputDevice device, int axis, int historyPos) {
        final InputDevice.MotionRange range =
                device.getMotionRange(axis, event.getSource());

        // A joystick at rest does not always report an absolute position of
        // (0,0). Use the getFlat() method to determine the range of values
        // bounding the joystick axis center.
        if (range != null) {
            final float flat = range.getFlat();
            final float value =
                    historyPos < 0 ? event.getAxisValue(axis):
                            event.getHistoricalAxisValue(axis, historyPos);

            // Ignore axis values that are within the 'flat' region of the
            // joystick axis center.
            if (Math.abs(value) > flat) {
                return value;
            }
        }
        return 0;
    }

    private void processTriggerInput(MotionEvent event) {
        float RTrigger = event.getAxisValue(MotionEvent.AXIS_GAS);
        float LTrigger = event.getAxisValue(MotionEvent.AXIS_BRAKE);
        if(remote== true) {
            if (RTrigger > 0.07) {
                kart.setDriveSpeed((int) ((RTrigger - LTrigger) * 15));
                remoteSpeedPos = (int) ((RTrigger - LTrigger) * 15);
            } else if (LTrigger > 0.07) {
                kart.setDriveSpeed((int) (LTrigger * (-15)));
                remoteSpeedPos = (int) (LTrigger * (-15));
            } else {
                kart.setDriveSpeed(0);
                remoteSpeedPos = 0;
            }
        }
    }

}
