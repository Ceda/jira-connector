class JiraController < HandleController
  def index
    case change['field']
    when 'status'
      Connector.github.change_labels(push['issue'], change)
    when 'assignee'
      Connector.github.assign_to_user(push['issue'], change)
    end

    render body: nil, status: 200
  end

  private

  def change
    push['changelog']['items'].first
  end
end
