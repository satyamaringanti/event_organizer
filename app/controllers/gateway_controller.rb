class GatewayController < ApplicationController
  before_action :ensure_token

  def fetch_events
    events, msg = [nil, nil]
    if params[:organization].present? && params[:hostname].present? && params[:count].present?
      events = Event.joins(:organizations).where('organizations.name': params[:organization], hostname: params[:hostname]).order('created_at desc').limit(params[:count])
      msg = events.present? ? "#{events.count} events of #{params[:organization]} with hostname #{params[:hostname]} returned" : 'No events'
      events = events.collect{|e| EventSerializer.new(e).attributes }
    elsif params[:organization].present? && params[:hostname].present?
      events = Event.joins(:organizations).where('organizations.name': params[:organization], hostname: params[:hostname]).order('created_at desc')
      msg = events.present? ? "#{events.count} events of #{params[:organization]} with hostname #{params[:hostname]} returned" : 'No events'
      events = events.collect{|e| EventSerializer.new(e).attributes }
    elsif params[:organization].present?
      events = Event.joins(:organizations).where('organizations.name': params[:organization]).order('created_at desc')
      msg = events.present? ? "#{events.count} events of #{params[:organization]} returned" : 'No events'
      events = events.collect{|e| EventSerializer.new(e).attributes }
    elsif params[:hostname].present?
      events = Event.where(hostname: params[:hostname]).order('created_at desc')
      msg = events.present? ? "#{events.count} events with hostname #{params[:hostname]} returned" : 'No events'
      events = events.collect{|e| EventSerializer.new(e).attributes }
    elsif params[:count].present? && params[:count].to_i > 0
      events = Event.order('created_at desc').limit(params[:count])
      msg = events.present? ? "#{events.count} events returned" : 'No events'
      events = events.collect{|e| EventSerializer.new(e).attributes }
    else
      events = Event.order('created_at desc')
      msg = events.present? ? 'All events returned' : 'No events'
      events = events.collect{|e| EventSerializer.new(e).attributes }
    end
    success_response(events, msg)
  end

  def create_event
    logger.info params.inspect
    required(params[:event], :title, :description, :hostname, :organizations)
    # fetching or creating an organization
    org_list = params[:event][:organizations]
    existing_orgs = Organization.where("name in (?)", org_list)
    missing_orgs = org_list - existing_orgs.map(&:name)
    new_org_ids = missing_orgs.collect do |org_name|
      new_org = Organization.create('name': org_name)
      new_org.id
    end
    org_ids = existing_orgs.map(&:id) + new_org_ids
    # creating an event based on params
    event = Event.new(event_attrs)
    if event.save
      # save organization_events relation table
      org_ids.each{|org_id| OrganizationEvent.create(event_id: event.id, organization_id: org_id) }
      success_response(EventSerializer.new(event), 'Event created')
    else
      error_response(nil, event.errors.full_messages.first, 412)
    end
  end

  def event_attrs
    params.require(:event).permit(:title, :description, :hostname)
  end
end
