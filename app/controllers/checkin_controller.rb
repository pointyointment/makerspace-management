class CheckinController < ApplicationController
  def index
    @currently_checked_in = User.checked_in_users
    @currently_checked_in_alph = User.checked_in_users.order(:first_name, :last_name)
    i = 1
    @active_events = {}
    #Find out which events are active and set to @active_events to display on checkin page
    Event.all.each do |event|
      if event.event_start.to_i-30.minutes < Time.now.to_i && event.event_end.to_i > Time.now.to_i
        @active_events[i] = event
        i += 1
      else
      end

    end


  end

  def event_checkin
    i = 0
    @active_events = {}
    Event.all.each do |event|
      if event.event_start.to_i < Time.now.to_i && event.event_end.to_i < Time.now.to_i
        @active_events[i] = event
      else
      end
      i += 1
    end
  end

  def checkin
    # if the user id param is passed, find the user's email address by their user id
    if checkin_params[:user_id].present?
      email = User.find(checkin_params[:user_id]).email

    else
      email = checkin_params[:email].downcase.strip
      # append @mtu.edu if the email already doesn't contain the domain
      # this allows users to enter only their username and username@mtu.edu
      email += "@mtu.edu" unless email.include?("@mtu.edu")
    end
    unless email.present? && valid_email?(email)
      # we currently only allow checking in and out with mtu emails
      redirect_to checkin_path, notice: "Invalid email. You must use a @mtu.edu email."
      return
    end

    user = User.find_by(email: email)

    unless user.present?
      first_name = checkin_params[:first_name]
      last_name = checkin_params[:last_name]

      # we need to create a user record, but first need more data
      if first_name.present? && last_name.present?
        # create the user with the information provided, with a random password
        # and only member status (least privilege)
        user = User.new(
          email: email,
          first_name: first_name,
          last_name: last_name,
          member_since: Time.now,
          password: Devise.friendly_token,
          user_type: 'Member'
        )

        unless user.save
          redirect_to checkin_path, notice: "An unexpected error occurred. Please try again."
          return
        end
      else
        # we're missing information, request the information from the user
        if (!first_name.nil? && first_name.empty?) || (!last_name.nil? && last_name.empty?)
          # the user left at least one of the name fields blank, provide a bit of help
          redirect_to checkin_first_time_path(email: checkin_params[:email], reason: checkin_params[:reason]), notice: "Both first and last name are required fields."
        else
          redirect_to checkin_first_time_path(email: checkin_params[:email], reason: checkin_params[:reason])
        end
        return
      end
    end

    last_punch = user.most_recent_punch
    message = ""
    if last_punch.present? && last_punch.in?
    elsif checkin_params[:reason].nil?
      redirect_to checkin_path, alert: "Not checked in! Please provide a checkin reason."
      return
    else
    end
    if last_punch.present? && last_punch.in?
      # the user was checked in, we need to check them out
      user.punch_out!
      message = "been checked out."
    else
      # this is the user's first time, or they were checked out last, check them in
      user.punch_in!(checkin_params[:reason])
      message = "been checked in."
    end

    if current_user.present?
      redirect_to checkin_path, notice: "#{user.first_name} has #{message}"
      return
    else
      redirect_to checkin_path, notice: "Thanks #{user.first_name}! You've #{message}"
      return
    end

  end

  def checkout_all
    User.checked_in_users.each do |user|
      user.punch_out!
    end
    redirect_to checkin_path, notice: "Everyone has been checked out."
  end



private

  def checkin_params
    params.permit(:email, :reason, :first_name, :last_name, :user_id)
  end

  def valid_email?(email)
    email.ends_with?('@mtu.edu')
  end
end
