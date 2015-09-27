
%Rib Inputs

wingname = 'Wing1';
%text file with x-y points of airfoil shape,
%two columns of data points with a constant delimeter
airfoil_txt='sd7037.txt';
%major chord length in mm
chord_length = 180;
%spar width in mm
spar_width = 3.175;
%rib width in mm
rib_width = 3.175;
%kerf of laser cutter in mm
kerf = 0.3;
%spacing between items on pdf file in mm
pdf_space = 2;
%thinckness of carbon spar cap in mm
spar_cap_thickness = 0.9;
%designed gap between the spar cap and the skin at the notch in mm
notch_skin_gap = 1;
%thickness of balsa skin in mm
skin_thickness = 0.79;
%front notch x location as a fraction of major chord length
front_notch_x_percentage = 0.25;
%back notch x location as a fraction of major chord length
back_notch_x_percentage = 0.6;
%carbon tube x location as a fraction of major chord length
carbon_tube_x_percentage = 0.15;
%carbon tube diameter in mm
carbon_tube_diameter = 7.95;
%lightning hole x location as a fraction of major chord length
lightning_hole_x_percentage = .45;
%lightning hole length in mm
lightning_hole_length = 10;
%lightning hole width in mm
lightning_hole_width = 5;
%servo x location as a fraction of major chord length
servo_x_percentage = .45;
%servo length in mm
servo_length = 20;
%servo width in mm
servo_width = 8.3;
%servo_spacing_to_hole = 3;
%servo_hole_diameter = 2;
%aileron chord length as a fraction of major chord length
aileron_chord_frac = .25;
%gap between the aileron and the rest of the wing
aileron_chord_gap = 3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Spar Inputs

%aircraft span in mm
span = 1400;
%span of the center spar in mm
center_span = 600;
%spacing between rib F's (inside to inside)
fuselage_connect_spacing = 30;
%number of ribs in the center spar
num_ribs_center = 12;
%span of both ailerons as a fraction of the total span
aileron_span_frac = 0.4;
%distance from the center of the wing to the center of each aileron in mm
aileron_span_loc = 500;
%number of ribs in each edge spar inside the aileron
num_ribs_edge_middle_notches = 4;
%number of ribs in each edge spar on each side of the aileron
num_ribs_edge_outside_notches = 3;
%depth of each aileron spar
aileron_spar_depth = 12;
%spanwise gap between wing and aileron on each side
aileron_span_gap = 2.5;

num_aileron_spar_tabs = 3;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%PDF Inputs

%size of balsa piece - x dimension
pdf_x = 700;
%size of balsa piece - y dimension
pdf_y = 100;
%line width for figures
linewidth = 0.01;

%Define number of each kind of rib needed
num_a_1_8 = 14;
num_b_1_8 = 8;
num_d_1_8 = 8;
%check if ribD needed > rib B; need extra rib D
num_c_1_8 = 2;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Rib Calculations

%Import airfoil data file
airfoil = dlmread(airfoil_txt);
x=airfoil(:,1);
front = min(x);
back = max(x);
chord= back-front;

%Scale airfoil to chord length
airfoil = airfoil*chord_length/chord;
datapts = length(airfoil(:,1));
airfoil(datapts+1,1) = airfoil(1,1);
airfoil(datapts+1,2) = airfoil(1,2);

%Find airfoil properties
x=airfoil(:,1);
y=airfoil(:,2);
front = min(x);
back = max(x);
bottom = min(y);
top = max(y);
chord= back-front;
height = top-bottom;

%Calculate x along chord locations
front_notch_x = front_notch_x_percentage * chord + front;
back_notch_x = back_notch_x_percentage * chord + front;
carbon_tube_x = carbon_tube_x_percentage*chord + front;
lightning_hole_x = lightning_hole_x_percentage*chord + front;
servo_x = servo_x_percentage*chord + front;
aileron_x_l = (1-aileron_chord_frac)*chord + front - aileron_chord_gap/2.0;
aileron_x_r = (1-aileron_chord_frac)*chord + front + aileron_chord_gap/2.0;

%Separate top and bottom at airfoil
half = floor(datapts/2);
airfoil_top = airfoil(1:half,1:2);
airfoil_bot = airfoil(half+1:datapts,1:2);

%Calculate front notch values
front_notch_y_t = interp1(airfoil_top(:,1),airfoil_top(:,2),front_notch_x);
front_notch_y_b = interp1(airfoil_bot(:,1),airfoil_bot(:,2),front_notch_x);
front_notch_h = front_notch_y_t-front_notch_y_b;
front_notch_y = front_notch_y_t-front_notch_h/2.0;
front_notch_x_L = front_notch_x - spar_width / 2.0 + kerf;
front_notch_x_R = front_notch_x + spar_width / 2.0 - kerf;
front_notch_x_L_C = front_notch_x - 3*spar_width / 2.0 + kerf;
front_notch_x_R_C = front_notch_x + 3*spar_width / 2.0 - kerf;

%Calculate bottom notch values
bottom_notch_y = front_notch_y_b + spar_cap_thickness...
    + notch_skin_gap + skin_thickness;
back_notch_y_t = interp1(airfoil_top(:,1),airfoil_top(:,2),back_notch_x);
back_notch_y_b = interp1(airfoil_bot(:,1),airfoil_bot(:,2),back_notch_x);
back_notch_h = back_notch_y_t-back_notch_y_b;
back_notch_y = back_notch_y_t-back_notch_h/2.0;
back_notch_x_L = back_notch_x - spar_width / 2.0 + kerf;
back_notch_x_R = back_notch_x + spar_width / 2.0 - kerf;

%Calculate carbon tube values
carbon_tube_y_t = interp1(airfoil_top(:,1),airfoil_top(:,2),carbon_tube_x);
carbon_tube_y_b = interp1(airfoil_bot(:,1),airfoil_bot(:,2),carbon_tube_x);
carbon_tube_h = carbon_tube_y_t - carbon_tube_y_b;
carbon_tube_y = carbon_tube_y_t-carbon_tube_h/2.0;

%Create variables for making circles
t_full = linspace(0,2*pi);
t_left = linspace(pi/2,3*pi/2);
t_right = linspace(3*pi/2,5*pi/2);

%Calculate lightning hole values
lightning_hole_y_t = interp1(airfoil_top(:,1),...
    airfoil_top(:,2),lightning_hole_x);
lightning_hole_y_b = interp1(airfoil_bot(:,1),...
    airfoil_bot(:,2),lightning_hole_x);
lightning_hole_h = lightning_hole_y_t - lightning_hole_y_b;
lightning_hole_y = lightning_hole_y_t-lightning_hole_h/2.0;

%Calculate servo values
servo_y_t = interp1(airfoil_top(:,1),airfoil_top(:,2),servo_x);
servo_y_b = interp1(airfoil_bot(:,1),airfoil_bot(:,2),servo_x);
servo_h = servo_y_t - servo_y_b;
servo_y = servo_y_t-servo_h/2.0;

%Calculate aileron values
aileron_y_l_t = interp1(airfoil_top(:,1),airfoil_top(:,2),aileron_x_l);
aileron_y_l_b = interp1(airfoil_bot(:,1),airfoil_bot(:,2),aileron_x_l);
aileron_h_l = aileron_y_l_t - aileron_y_l_b;
aileron_y_l = aileron_y_l_t-aileron_h_l/2.0;
aileron_y_r_t = interp1(airfoil_top(:,1),airfoil_top(:,2),aileron_x_r);
aileron_y_r_b = interp1(airfoil_bot(:,1),airfoil_bot(:,2),aileron_x_r);
aileron_h_r = aileron_y_r_t - aileron_y_r_b;
aileron_y_r = aileron_y_r_t-aileron_h_r/2.0;

aileron_y_center = (aileron_y_l_t+aileron_y_l_b)/2.0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Spar Calculations

%Front and Back Spar
%Calculate spar heights
front_spar_h = front_notch_h-2*spar_cap_thickness-2*notch_skin_gap;
back_spar_h = back_notch_h-2*notch_skin_gap;
%Calculate base for front spar
front_spar_center_rect_z = [0;center_span;center_span;0;0];
front_spar_center_rect_y = [0;0;front_spar_h;front_spar_h;0];
%Calculate base for back spar
back_spar_center_rect_z = [0;center_span;center_span;0;0];
back_spar_center_rect_y = [0;0;back_spar_h;back_spar_h;0]+front_spar_h + pdf_space;
%Calculate locations of rib F
ribF_z_l = (center_span - fuselage_connect_spacing)/2.0;
ribF_z_r = (center_span + fuselage_connect_spacing)/2.0;
%Calculate other rib F values
ribF_notch_l_z = [ribF_z_l;ribF_z_l;ribF_z_l-rib_width;ribF_z_l-rib_width];
ribF_notch_r_z = [ribF_z_r;ribF_z_r;ribF_z_r+rib_width;ribF_z_r+rib_width];
notch_front_spar_y = [0;front_spar_h/2.0;front_spar_h/2.0;0];
notch_back_spar_y = [0;back_spar_h/2.0;back_spar_h/2.0;0] + front_spar_h + pdf_space;
%Calculate front spar rib A/C notch locations
front_spar_center_left_z = linspace(rib_width/2,ribF_z_l-rib_width/2,num_ribs_center/2);
front_spar_center_right_z = linspace(center_span-rib_width/2,ribF_z_r+rib_width/2,num_ribs_center/2);
%Calculate back spar rib A/C notch locations
back_spar_center_left_z = front_spar_center_left_z;
back_spar_center_right_z = front_spar_center_right_z;

%Edge Spar
%Calculate span of edge sections
edge_span = (span-center_span)/2.0;
%Calculate base for front spar
front_spar_edge_rect_z = [0;edge_span;edge_span;0;0];
front_spar_edge_rect_y = [0;0;front_spar_h;front_spar_h;0];
%Calculate base for back spar
back_spar_edge_rect_z = [0;edge_span;edge_span;0;0];
back_spar_edge_rect_y = [0;0;back_spar_h;back_spar_h;0]+front_spar_h + pdf_space;
%Calculate aileron span
aileron_span = aileron_span_frac*span/2.0;
%Calculate aileron notch positions
aileron_center_z =  edge_span + center_span/2.0 - aileron_span_loc;
aileron_left_z = aileron_center_z - aileron_span/2.0;
aileron_right_z = aileron_center_z + aileron_span/2.0;
%Calculate aileron notch positions
aileron_notch_l_z = [aileron_left_z;aileron_left_z;...
    aileron_left_z-rib_width;aileron_left_z-rib_width];
aileron_notch_r_z = [aileron_right_z;aileron_right_z;...
    aileron_right_z+rib_width;aileron_right_z+rib_width];
%Calculate front spar rib A/C notch locations
front_spar_edge_left_z = linspace(rib_width/2,aileron_left_z-rib_width/2,num_ribs_edge_outside_notches);
front_spar_edge_right_z = linspace(edge_span-rib_width/2,aileron_right_z+rib_width/2,num_ribs_edge_outside_notches);
%Calculate back spar rib A/C notch locations
back_spar_edge_left_z = front_spar_edge_left_z;
back_spar_edge_right_z = front_spar_edge_right_z;
%Calculate front spar rib A/C notch locations
front_spar_edge_mid_z = linspace(aileron_left_z-rib_width/2,aileron_right_z+rib_width/2,num_ribs_edge_middle_notches+2);
%Calculate back spar rib A/C notch locations
back_spar_edge_mid_z = front_spar_edge_mid_z;

%Calculate base for front spar
aileron_spar_span = aileron_span - 2*aileron_span_gap;
aileron_spar_rect_x = [0;0;aileron_spar_span;aileron_spar_span];
aileron_spar_rect_bot_y = [aileron_spar_depth;0;0;aileron_spar_depth];
aileron_spar_rect_top_y = [0;aileron_spar_depth;aileron_spar_depth;0]...
    +aileron_spar_depth+aileron_chord_gap;


aileron_spar_bot_notch_x = linspace(aileron_left_z-rib_width/2,...
aileron_right_z+rib_width/2,num_ribs_edge_middle_notches+2)...
-aileron_left_z-aileron_span_gap;
aileron_spar_bot_notch_y = [0;aileron_spar_depth/2.0;aileron_spar_depth/2.0;0];

aileron_spar_top_notch_x = linspace(0+rib_width/2.0,aileron_spar_span-rib_width/2.0,num_ribs_edge_middle_notches);
aileron_spar_top_notch_y = [2*aileron_spar_depth+aileron_chord_gap;1.5*aileron_spar_depth+aileron_chord_gap;...
    1.5*aileron_spar_depth+aileron_chord_gap;2*aileron_spar_depth+aileron_chord_gap];

aileron_spar_tabs_y = [aileron_spar_depth;aileron_spar_depth+aileron_chord_gap];
aileron_spar_tabs_x = linspace(rib_width/2,aileron_spar_span-rib_width/2,num_aileron_spar_tabs+2);


figure;
axis off;
axis equal;
hold on;
plot(aileron_spar_rect_x,aileron_spar_rect_bot_y,'-k','LineWidth',linewidth);
plot(aileron_spar_rect_x,aileron_spar_rect_top_y,'-k','LineWidth',linewidth);

for i = 2:num_ribs_edge_middle_notches+1
    %mid front
    plot([aileron_spar_bot_notch_x(i)-rib_width/2;aileron_spar_bot_notch_x(i)-rib_width/2;...
        aileron_spar_bot_notch_x(i)+rib_width/2;aileron_spar_bot_notch_x(i)+rib_width/2;],...
        aileron_spar_bot_notch_y,'k-','LineWidth',linewidth);
end

for i = 1:num_ribs_edge_middle_notches
    %mid front
    plot([aileron_spar_top_notch_x(i)-rib_width/2;aileron_spar_top_notch_x(i)-rib_width/2;...
        aileron_spar_top_notch_x(i)+rib_width/2;aileron_spar_top_notch_x(i)+rib_width/2;],...
        aileron_spar_top_notch_y,'k-','LineWidth',linewidth);
end

for i=2:num_aileron_spar_tabs+1
    plot([aileron_spar_tabs_x(i)-rib_width/2;aileron_spar_tabs_x(i)-rib_width/2],...
        aileron_spar_tabs_y,'-k','LineWidth',linewidth);
    plot([aileron_spar_tabs_x(i)+rib_width/2;aileron_spar_tabs_x(i)+rib_width/2],...
        aileron_spar_tabs_y,'-k','LineWidth',linewidth);
end

plot([0;aileron_spar_tabs_x(2)-rib_width/2],...
    [aileron_spar_depth,aileron_spar_depth],'-k','LineWidth',linewidth);
plot([0;aileron_spar_tabs_x(2)-rib_width/2],...
    [aileron_spar_depth+aileron_chord_gap,aileron_spar_depth+aileron_chord_gap],...
    '-k','LineWidth',linewidth);

for i=2:num_aileron_spar_tabs
plot([aileron_spar_tabs_x(i)+rib_width/2;aileron_spar_tabs_x(i+1)-rib_width/2],...
    [aileron_spar_depth,aileron_spar_depth],'-k','LineWidth',linewidth);
plot([aileron_spar_tabs_x(i)+rib_width/2;aileron_spar_tabs_x(i+1)-rib_width/2],...
    [aileron_spar_depth+aileron_chord_gap,aileron_spar_depth+aileron_chord_gap],...
    '-k','LineWidth',linewidth);
end

plot([aileron_spar_tabs_x(num_aileron_spar_tabs+1)+rib_width/2;aileron_spar_span],...
    [aileron_spar_depth,aileron_spar_depth],'-k','LineWidth',linewidth);
plot([aileron_spar_tabs_x(num_aileron_spar_tabs+1)+rib_width/2;aileron_spar_span],...
    [aileron_spar_depth+aileron_chord_gap,aileron_spar_depth+aileron_chord_gap],...
    '-k','LineWidth',linewidth);


% saveas(gcf,wingname+'_AileronSpar.pdf');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Skin Calculations

arc_length = 0;
for i=1:datapts-1
    arc_length = arc_length +((airfoil(i,1)-airfoil(i+1,1))^2+(airfoil(i,2)-airfoil(i+1,2))^2)^(1/2);
end

skin_covered = 0;
skin_curr = 0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Fuselage Connector Calculations

Fuselage_Depth = 50;
Fuselage_front_x = 10;
Fuselage_Connector_Length = 100;
Fuselage_Hole_Depth = 30;
Fuselage_Hole_Diameter = 6.35;
Fuselage_Hole_1_x = 30;
Fuselage_Hole_2_x = 70;
Fuselage_Tab_Width = 5;
%Thickness of Base Plate
Fuselage_Tab_Depth = 3.175;
Fuselage_Tab_1_x = 20;
Fuselage_Tab_2_x = 80;


%airfoil_ribF =
%make sure to leave hole for spar cap

fuselage_back_x = Fuselage_front_x + Fuselage_Connector_Length;
fuselage_y_front = interp1(airfoil_bot(:,1),airfoil_bot(:,2),Fuselage_front_x);
fuselage_y_back = interp1(airfoil_bot(:,1),airfoil_bot(:,2),fuselage_back_x);

fuselage_x = [Fuselage_front_x;Fuselage_front_x;...
    Fuselage_front_x+Fuselage_Tab_1_x;Fuselage_front_x+Fuselage_Tab_1_x;...
    Fuselage_front_x+Fuselage_Tab_1_x+Fuselage_Tab_Width;Fuselage_front_x+Fuselage_Tab_1_x+Fuselage_Tab_Width;...
    Fuselage_front_x+Fuselage_Tab_2_x;Fuselage_front_x+Fuselage_Tab_2_x;...
    Fuselage_front_x+Fuselage_Tab_2_x+Fuselage_Tab_Width;Fuselage_front_x+Fuselage_Tab_2_x+Fuselage_Tab_Width;...
    fuselage_back_x;fuselage_back_x];
fuselage_y = [fuselage_y_front;
    -Fuselage_Depth;-Fuselage_Depth;...
    -Fuselage_Depth-Fuselage_Tab_Depth;-Fuselage_Depth-Fuselage_Tab_Depth;...
    -Fuselage_Depth;-Fuselage_Depth;...
    -Fuselage_Depth-Fuselage_Tab_Depth;-Fuselage_Depth-Fuselage_Tab_Depth;...
    -Fuselage_Depth;-Fuselage_Depth;...
    fuselage_y_back];



figure;
axis off;
axis equal;
hold on;
x_shift = chord+pdf_space;
y_shift = 0;
%y_shift = top+Fuselage_Depth+pdf_space;
for i=0:1
    plot(x+i*x_shift,y,'k-','LineWidth',linewidth);
    plot(fuselage_x+i*x_shift,fuselage_y,'k-','LineWidth',linewidth);
    plot(Fuselage_front_x+Fuselage_Hole_1_x + Fuselage_Hole_Diameter/2*cos(t_full)+i*x_shift,...
        -Fuselage_Hole_Depth + Fuselage_Hole_Diameter/2*sin(t_full),'k-','LineWidth',linewidth);
    plot(Fuselage_front_x+Fuselage_Hole_2_x + Fuselage_Hole_Diameter/2*cos(t_full)+i*x_shift,...
        -Fuselage_Hole_Depth + Fuselage_Hole_Diameter/2*sin(t_full),'k-','LineWidth',linewidth);
    plot([front_notch_x_L+i*x_shift; front_notch_x_R+i*x_shift],...
        [front_notch_y+y_shift; front_notch_y+y_shift],...
        'k-','LineWidth',linewidth);
    plot([front_notch_x_L+i*x_shift; front_notch_x_L+i*x_shift],...
        [front_notch_y+y_shift; top+y_shift],...
        'k-','LineWidth',linewidth);
    plot([front_notch_x_R+i*x_shift; front_notch_x_R+i*x_shift],...
        [front_notch_y+y_shift; top+y_shift],...
        'k-','LineWidth',linewidth);
    %bottom notch
    plot([front_notch_x_L+i*x_shift; front_notch_x_R+i*x_shift],...
        [bottom_notch_y+y_shift; bottom_notch_y+y_shift],...
        'k-','LineWidth',linewidth);
    plot([front_notch_x_L+i*x_shift; front_notch_x_L+i*x_shift],...
        [bottom_notch_y+y_shift; bottom+y_shift],...
        'k-','LineWidth',linewidth);
    plot([front_notch_x_R+i*x_shift; front_notch_x_R+i*x_shift],...
        [bottom_notch_y+y_shift; bottom+y_shift],...
        'k-','LineWidth',linewidth);
    %back notch
    plot([back_notch_x_L+i*x_shift; back_notch_x_R+i*x_shift],...
        [back_notch_y+y_shift; back_notch_y+y_shift],'k-','LineWidth',linewidth);
    plot([back_notch_x_L+i*x_shift; back_notch_x_L+i*x_shift],...
        [back_notch_y+y_shift; top+y_shift],'k-','LineWidth',linewidth);
    plot([back_notch_x_R+i*x_shift; back_notch_x_R+i*x_shift],...
        [back_notch_y+y_shift; top+y_shift],'k-','LineWidth',linewidth);
    %carbon tube
    plot(carbon_tube_x + carbon_tube_diameter/2*cos(t_full)+i*x_shift,...
        carbon_tube_y + carbon_tube_diameter/2*sin(t_full)+y_shift,'k-','LineWidth',linewidth);
    %lightning hole
    plot(lightning_hole_x - lightning_hole_length/2 + lightning_hole_width/2*cos(t_left)+i*x_shift,...
        lightning_hole_y + lightning_hole_width/2*sin(t_left)+y_shift,'k-','LineWidth',linewidth);
    plot(lightning_hole_x + lightning_hole_length/2 + lightning_hole_width/2*cos(t_right)+i*x_shift,...
        lightning_hole_y + lightning_hole_width/2*sin(t_right)+y_shift,'k-','LineWidth',linewidth);
    plot([lightning_hole_x - lightning_hole_length/2+i*x_shift; lightning_hole_x + lightning_hole_length/2+i*x_shift],...
        [lightning_hole_y + lightning_hole_width/2+y_shift; lightning_hole_y + lightning_hole_width/2+y_shift],'k-','LineWidth',linewidth);
    plot([lightning_hole_x - lightning_hole_length/2+i*x_shift; lightning_hole_x + lightning_hole_length/2+i*x_shift],...
        [lightning_hole_y - lightning_hole_width/2+y_shift; lightning_hole_y - lightning_hole_width/2+y_shift],'k-','LineWidth',linewidth);
end

% saveas(gcf,wingname+'_RibFs.pdf');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Create Skin pdfs

% while skin_covered<=arc_length
%     skin_left = arc_length-skin_covered;
%     if skin_left<=pdf_y
%         skin_curr = skin_left;
%     else
%         skin_curr = pdf_y;
%     end
%     skin_covered = skin_covered+skin_curr;
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Create Spar pdfs

%Plot Center Spars - front and back

%Initialize figure
figure;
axis off;
axis equal;
hold on;
%Plot front spar base
plot(front_spar_center_rect_z,front_spar_center_rect_y,'k-','LineWidth',linewidth);
%Plot back spar base
plot(back_spar_center_rect_z,back_spar_center_rect_y,'k-','LineWidth',linewidth);
%Plot rib F notches on front
plot(ribF_notch_l_z,notch_front_spar_y,'k-','LineWidth',linewidth);
plot(ribF_notch_r_z,notch_front_spar_y,'k-','LineWidth',linewidth);
%Plot rib F notches on back
plot(ribF_notch_l_z,notch_back_spar_y,'k-','LineWidth',linewidth);
plot(ribF_notch_r_z,notch_back_spar_y,'k-','LineWidth',linewidth);
%Plot rest of notches
for i = 1:num_ribs_center/2-1
    %left front
    plot([front_spar_center_left_z(i)-rib_width/2;front_spar_center_left_z(i)-rib_width/2;...
        front_spar_center_left_z(i)+rib_width/2;front_spar_center_left_z(i)+rib_width/2;],...
        notch_front_spar_y,'k-','LineWidth',linewidth);
    %right front
    plot([front_spar_center_right_z(i)-rib_width/2;front_spar_center_right_z(i)-rib_width/2;...
        front_spar_center_right_z(i)+rib_width/2;front_spar_center_right_z(i)+rib_width/2;],...
        notch_front_spar_y,'k-','LineWidth',linewidth);
    %left back
    plot([back_spar_center_left_z(i)-rib_width/2;back_spar_center_left_z(i)-rib_width/2;...
        back_spar_center_left_z(i)+rib_width/2;back_spar_center_left_z(i)+rib_width/2;],...
        notch_back_spar_y,'k-','LineWidth',linewidth);
    %right back
    plot([back_spar_center_right_z(i)-rib_width/2;back_spar_center_right_z(i)-rib_width/2;...
        back_spar_center_right_z(i)+rib_width/2;back_spar_center_right_z(i)+rib_width/2;],...
        notch_back_spar_y,'k-','LineWidth',linewidth);
end


% saveas(gcf,wingname+'_CenterSpar.pdf');

%Plot Edge Spars - front and back

figure;
hold on;
axis off;
axis equal;
%Plot front spar base
plot(front_spar_edge_rect_z,front_spar_edge_rect_y,'k-','LineWidth',linewidth);
%Plot back spar base
plot(back_spar_edge_rect_z,back_spar_edge_rect_y,'k-','LineWidth',linewidth);
%Plot notches on outside edge of aileron - front
plot(aileron_notch_l_z,notch_front_spar_y,'k-','LineWidth',linewidth);
plot(aileron_notch_r_z,notch_front_spar_y,'k-','LineWidth',linewidth);
%Plot notches on outside edge of aileron - back
plot(aileron_notch_l_z,notch_back_spar_y,'k-','LineWidth',linewidth);
plot(aileron_notch_r_z,notch_back_spar_y,'k-','LineWidth',linewidth);
%Plot rest of notches outside aileron
for i = 1:num_ribs_edge_middle_notches-2
    %left front
    plot([front_spar_edge_left_z(i)-rib_width/2;front_spar_edge_left_z(i)-rib_width/2;...
        front_spar_edge_left_z(i)+rib_width/2;front_spar_edge_left_z(i)+rib_width/2;],...
        notch_front_spar_y,'k-','LineWidth',linewidth);
    %right front
    plot([front_spar_edge_right_z(i)-rib_width/2;front_spar_edge_right_z(i)-rib_width/2;...
        front_spar_edge_right_z(i)+rib_width/2;front_spar_edge_right_z(i)+rib_width/2;],...
        notch_front_spar_y,'k-','LineWidth',linewidth);
    %left back
    plot([back_spar_edge_left_z(i)-rib_width/2;back_spar_edge_left_z(i)-rib_width/2;...
        back_spar_edge_left_z(i)+rib_width/2;back_spar_edge_left_z(i)+rib_width/2;],...
        notch_back_spar_y,'k-','LineWidth',linewidth);
    %right back
    plot([back_spar_edge_right_z(i)-rib_width/2;back_spar_edge_right_z(i)-rib_width/2;...
        back_spar_edge_right_z(i)+rib_width/2;back_spar_edge_right_z(i)+rib_width/2;],...
        notch_back_spar_y,'k-','LineWidth',linewidth);
end
%Plot notches inside aileron
for i = 2:num_ribs_edge_middle_notches+1
    %mid front
    plot([front_spar_edge_mid_z(i)-rib_width/2;front_spar_edge_mid_z(i)-rib_width/2;...
        front_spar_edge_mid_z(i)+rib_width/2;front_spar_edge_mid_z(i)+rib_width/2;],...
        notch_front_spar_y,'k-','LineWidth',linewidth);
    %mid back
    plot([back_spar_edge_mid_z(i)-rib_width/2;back_spar_edge_mid_z(i)-rib_width/2;...
        back_spar_edge_mid_z(i)+rib_width/2;back_spar_edge_mid_z(i)+rib_width/2;],...
        notch_back_spar_y,'k-','LineWidth',linewidth);
end

% saveas(gcf,wingname+'_EdgeSpar.pdf');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plot Ribs

rib_count_1_8=0;
num_ribs_1_8 = num_a_1_8+num_b_1_8+num_c_1_8;

%plot ribs A,B,C,D 1/8"
pdf_counter = 1;
%Repeat until all ribs have been assigned to a pdf
while rib_count_1_8<num_ribs_1_8
    %new fig
    figure;
    hold on;
    axis off;
    axis equal;
    %define x and y spacing within limits of max pdf size
    for x_shift = linspace(0,(floor(pdf_x/chord)-1)*(chord+pdf_space),floor(pdf_x/chord))
        for y_shift = -linspace(0,(floor(pdf_y/height)-1)*(height+pdf_space),floor(pdf_y/height))
            plot(airfoil(:,1)+x_shift,...
                airfoil(:,2)+y_shift,'k-','LineWidth',linewidth);
            axis equal;
            %front notch
            if rib_count_1_8 < num_a_1_8+num_b_1_8
                plot([front_notch_x_L+x_shift; front_notch_x_R+x_shift],...
                    [front_notch_y+y_shift; front_notch_y+y_shift],...
                    'k-','LineWidth',linewidth);
                plot([front_notch_x_L+x_shift; front_notch_x_L+x_shift],...
                    [front_notch_y+y_shift; top+y_shift],...
                    'k-','LineWidth',linewidth);
                plot([front_notch_x_R+x_shift; front_notch_x_R+x_shift],...
                    [front_notch_y+y_shift; top+y_shift],...
                    'k-','LineWidth',linewidth);
                %bottom notch
                plot([front_notch_x_L+x_shift; front_notch_x_R+x_shift],...
                    [bottom_notch_y+y_shift; bottom_notch_y+y_shift],...
                    'k-','LineWidth',linewidth);
                plot([front_notch_x_L+x_shift; front_notch_x_L+x_shift],...
                    [bottom_notch_y+y_shift; bottom+y_shift],...
                    'k-','LineWidth',linewidth);
                plot([front_notch_x_R+x_shift; front_notch_x_R+x_shift],...
                    [bottom_notch_y+y_shift; bottom+y_shift],...
                    'k-','LineWidth',linewidth);
            else if rib_count_1_8 < num_a_1_8+num_b_1_8+num_c_1_8
                    %front notch
                    plot([front_notch_x_L_C+x_shift; front_notch_x_R_C+x_shift],...
                        [front_notch_y+y_shift; front_notch_y+y_shift],...
                        'k-','LineWidth',linewidth);
                    plot([front_notch_x_L_C+x_shift; front_notch_x_L_C+x_shift],...
                        [front_notch_y+y_shift; top+y_shift],...
                        'k-','LineWidth',linewidth);
                    plot([front_notch_x_R_C+x_shift; front_notch_x_R_C+x_shift],...
                        [front_notch_y+y_shift; top+y_shift],...
                        'k-','LineWidth',linewidth);
                    %bottom notch
                    plot([front_notch_x_L_C+x_shift; front_notch_x_R_C+x_shift],...
                        [bottom_notch_y+y_shift; bottom_notch_y+y_shift],...
                        'k-','LineWidth',linewidth);
                    plot([front_notch_x_L_C+x_shift; front_notch_x_L_C+x_shift],...
                        [bottom_notch_y+y_shift; bottom+y_shift],...
                        'k-','LineWidth',linewidth);
                    plot([front_notch_x_R_C+x_shift; front_notch_x_R_C+x_shift],...
                        [bottom_notch_y+y_shift; bottom+y_shift],...
                        'k-','LineWidth',linewidth);
                end
            end
            %back notch
            plot([back_notch_x_L+x_shift; back_notch_x_R+x_shift],...
                [back_notch_y+y_shift; back_notch_y+y_shift],'k-','LineWidth',linewidth);
            plot([back_notch_x_L+x_shift; back_notch_x_L+x_shift],...
                [back_notch_y+y_shift; top+y_shift],'k-','LineWidth',linewidth);
            plot([back_notch_x_R+x_shift; back_notch_x_R+x_shift],...
                [back_notch_y+y_shift; top+y_shift],'k-','LineWidth',linewidth);
            %carbon tube
            plot(carbon_tube_x + carbon_tube_diameter/2*cos(t_full)+x_shift,...
                carbon_tube_y + carbon_tube_diameter/2*sin(t_full)+y_shift,'k-','LineWidth',linewidth);
            %lightning hole
            if rib_count_1_8 < num_a_1_8 || rib_count_1_8 >= num_a_1_8+num_b_1_8
                plot(lightning_hole_x - lightning_hole_length/2 + lightning_hole_width/2*cos(t_left)+x_shift,...
                    lightning_hole_y + lightning_hole_width/2*sin(t_left)+y_shift,'k-','LineWidth',linewidth);
                plot(lightning_hole_x + lightning_hole_length/2 + lightning_hole_width/2*cos(t_right)+x_shift,...
                    lightning_hole_y + lightning_hole_width/2*sin(t_right)+y_shift,'k-','LineWidth',linewidth);
                plot([lightning_hole_x - lightning_hole_length/2+x_shift;...
                    lightning_hole_x + lightning_hole_length/2+x_shift],...
                    [lightning_hole_y + lightning_hole_width/2+y_shift;...
                    lightning_hole_y + lightning_hole_width/2+y_shift],'k-','LineWidth',linewidth);
                plot([lightning_hole_x - lightning_hole_length/2+x_shift;...
                    lightning_hole_x + lightning_hole_length/2+x_shift],...
                    [lightning_hole_y - lightning_hole_width/2+y_shift;...
                    lightning_hole_y - lightning_hole_width/2+y_shift],'k-','LineWidth',linewidth);
                %increment rib count
                rib_count_1_8 = rib_count_1_8 + 1;
            else if rib_count_1_8 < num_a_1_8+num_b_1_8
                    %servo
                    plot([servo_x - servo_length/2+x_shift;
                        servo_x + servo_length/2+x_shift;
                        servo_x + servo_length/2+x_shift;
                        servo_x - servo_length/2+x_shift;
                        servo_x - servo_length/2+x_shift;],...
                        [servo_y - servo_width/2+y_shift;
                        servo_y - servo_width/2+y_shift;
                        servo_y + servo_width/2+y_shift;
                        servo_y + servo_width/2+y_shift;
                        servo_y - servo_width/2+y_shift],'k-','LineWidth',linewidth);
                    %aileron cuts
                    plot([aileron_x_l+x_shift; aileron_x_l+x_shift],...
                        [aileron_y_l_b+y_shift; aileron_y_l_t+y_shift],'k-','LineWidth',linewidth);
                    plot([aileron_x_r+x_shift; aileron_x_r+x_shift],...
                        [aileron_y_r_b+y_shift; aileron_y_r_t+y_shift],'k-','LineWidth',linewidth);
                    %aileron notch
                    plot([aileron_x_l+x_shift; aileron_x_l-aileron_spar_depth/2.0+x_shift;...
                        aileron_x_l-aileron_spar_depth/2.0+x_shift;aileron_x_l+x_shift],...
                        [aileron_y_center+spar_width/2.0+y_shift; aileron_y_center+spar_width/2.0+y_shift;...
                        aileron_y_center-spar_width/2.0+y_shift;aileron_y_center-spar_width/2.0+y_shift],...
                        'k-','LineWidth',linewidth);
                    plot([aileron_x_r+x_shift; aileron_x_r+aileron_spar_depth/2.0+x_shift;...
                        aileron_x_r+aileron_spar_depth/2.0+x_shift;aileron_x_r+x_shift],...
                        [aileron_y_center+spar_width/2.0+y_shift; aileron_y_center+spar_width/2.0+y_shift;...
                        aileron_y_center-spar_width/2.0+y_shift;aileron_y_center-spar_width/2.0+y_shift],...
                        'k-','LineWidth',linewidth);
                    %increment rib count
                    rib_count_1_8 = rib_count_1_8 + 1;
                end
            end
            if rib_count_1_8 >= num_ribs_1_8
                break
            end
        end
        if rib_count_1_8 >= num_ribs_1_8
            break
        end
    end
%     saveas(gcf,wingname+'_Ribs'+pdf_counter+'.pdf');
    pdf_counter = pdf_counter+1;
end

hold off;
% print -depsc RibA.eps
% fixPSlinestyle('RibA.eps','RibAFix.eps');
