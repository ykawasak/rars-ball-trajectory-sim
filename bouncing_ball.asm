.eqv SYS_EXIT, 10
.eqv SYS_READINT, 5
.eqv SYS_PRINTINT, 1
.eqv SYS_PRINTSTRING, 4

.data
g:           .float 9.8             # gravitational acceleration
time_step:   .float 0.0625          # time step 1/16=0.0625
energy_loss: .float 0.9375          # energy loss factor sqrt(15/16) = 0.9375
initial_v:   .word 0                # store initial velocity as integer
width:       .word 256           
height:      .word 256          
zero_f:      .float 0.0             # set to zero to initialize
color:   .word 0x00FF0000       # for bitmap (red)

prompt:      .ascii "Enter initial velocity: \0"
newline:     .ascii "\n\0"

.text
.globl main

main:
    li a7, SYS_PRINTSTRING
    la a0, prompt
    ecall

    # read user input
    li a7, SYS_READINT
    ecall
    la t0, initial_v
    sw a0, 0(t0)                #  as integer

    # convert integer input to float
    lw t1, 0(t0)                # load integer input
    fcvt.s.w f4, t1             # convert int to float with single precision (f4 = initial velocity from the input)

    # load constants for general purpose registers
    la t0, g
    flw f1, 0(t0)               # for gravitational acceleration
    la t0, energy_loss
    flw f2, 0(t0)               # for energy loss
    la t0, time_step
    flw f3, 0(t0)               # for time step
    la t0, zero_f
    flw f0, 0(t0)               # set to zero to initialize the floating point register f0 here

    # initialize variables for rendering
    li t0, 0                    # counter for time step
    fmv.s f5, f0                # y = 0.0 (initial position)
    li t1, 0x10008000  
    lw t2, width               
    lw t3, color  
    li s1, 255                  # screen height - 1
    li s2, 256                  # total steps

simulation_loop:
    # finish after 256 steps
    bge t0, s2, end_simulation
    
    # when velocity is 0 then stop(never touch 0 in this case since loss is 1/16)
    feq.s t6, f4, f0         # f4 == 0?
    bnez t6, end_simulation  

    # convert y to int because screen accepts integer not float
    fcvt.w.s t5, f5            
    sub t4, s1, t5              # screen_y = 255 - t5

    # check within the screen
    bltz t4, skip_rendering         # skip if (y < 0)
    bge t4, s2, skip_rendering      # skip if (y >= 256)

    # render pixel
    mul t6, t4, t2              # t6 = y * width
    add t6, t6, t0              # t6 = (y * width) + x
    slli t6, t6, 2              # 2 left shifts so t6 *= 4 (each pixel is 4 bytes)
    add t6, t6, t1              # add base address of bitmap
    sw t3, 0(t6)                # write red color at pixel address

skip_rendering:
    # position update formula y = y + v * dt
    fmul.s f6, f4, f3           # f6 = v * dt
    fadd.s f5, f5, f6           # f5 = y + f6(v * dt)

    # if (y <= 0) then bounce(Recaluculate a new projectile motion with loss energy)
    fle.s t5, f5, f0            # Compare y <= 0
    bnez t5, bounce             # If true, handle bounce

    # v = v - g * dt
    fmul.s f6, f1, f3           # f6 = g * dt
    fsub.s f4, f4, f6           # v = v - f6

    addi t0, t0, 1              # increment time step
    j simulation_loop      

bounce:
    fsgnjn.s f4, f4, f4         # negate f4(velocity) to bounce upwards
    fmul.s f4, f4, f2           # apply energy loss(new velocity = old velocity * loss)
    fmv.s f5, f0                # set y = 0
    addi t0, t0, 1              # increment time step
    j simulation_loop           # go back to the loop to simulate a new trajectory

end_simulation:
    li a7, SYS_EXIT           
    ecall
