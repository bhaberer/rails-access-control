module RailsAccessControl
  module_function

  def allowed_hosts_only!
    return unless allowed_hosts.present?

    Rails.logger.debug(
      msg: 'RailsAccessControl IP Enforcement Check',
      requesting_ip: request.remote_ip,
      allowed_request: allowed_request?
    )

    head(:forbidden) unless allowed_request?
  end

  def reject_blocked_hosts!
    return unless blocked_hosts.present?

    Rails.logger.debug(
      msg: 'RailsAccessControl IP Enforcement Check',
      requesting_ip: request.remote_ip,
      blocked_request: blocked_request?
    )

    head(:forbidden) if blocked_request?
  end

  def blocked_hosts
    ENV['BLOCKED_HOSTS']
  end

  def allowed_hosts
    ENV['ALLOWED_HOSTS']
  end

  def allowed_request?
    allowed_hosts.include?(request.remote_ip)
  end

  def blocked_request?
    blocked_hosts.include?(request.remote_ip)
  end
end
