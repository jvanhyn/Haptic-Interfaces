function varargout = hapkitSimulator1(kh,bh,b,xd,vd,t)

    xh = zeros(length(t),1);    % handle position
    vh = zeros(length(t),1);    % handle velocity
    ah = zeros(length(t),1);    % handle acceleration
    fa = zeros(length(t),1);    % force applied by the actuator
    ffelt = zeros(length(t),1); % force felt by the human
    
    %% Dynamic Simulation
    
    for i = 1:length(t)
        % integrate the main state derivatives
        if (i == 1)
            % first time step has no difference between desired and actual
            % handle position
            vh(i) = vd(i);
            xh(i) = xd(i);
        else
            % simple Euler integration (you could use something more accurate!)
            vh(i) = vh(i-1) + ah(i-1) * T; 
            xh(i) = xh(i-1) + vh(i-1) * T; 
        end
     
        % force applied by the virtual environment
        if (xh(i) > xwall)
            fa(i) = kwall*(xwall-xh(i));
        else
            fa(i) = 0;
        end
     
        % force between the hand and the handle
        fh = kh*(xd(i)-xh(i));
        
        % force felt by the user
        ffelt(i) = -fh;
        
        % damping force
        ff = -(b+bh)*vh(i);
     
        % Compute the sum of forces on the handle: applied force, human force,
        % and friction force. 
        ftotal = fa(i) + fh + ff;
     
        % Compute the handle's new acceleration for the next iteration.
        ah(i) = ftotal / m;
        
    end

    varargout = [xh,vh,fa,fh];
end 