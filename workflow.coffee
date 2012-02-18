# Written by Kendall Buchanan (https://github.com/kendagriff)
# MIT License
# Version 0.0.1

class Backbone.Workflow
  attrName: 'workflow_state'

  constructor: (model, attrs={}) ->
    @model = model

    # Customize the workflow attribute name
    @attrName = attrs.attrName if attrs.attrName

    # Set up the model's initial workflow state
    params = { silent: true }
    params[@attrName] = _.keys(@model.workflow.states)[0]
    @model.set params
    
  # Handle transitions between states
  # Usage:
  #   @user.transition('go')
  transition: (event) ->
    state = @model.workflow.states[@model.workflowState()]
    e = state.events[event]
    if e
      params = {}
      params[@attrName] = e.transitionsTo
      @model.set params

      # Handle Callbacks
      # upper = event.charAt(0)
      cb = @model["on#{event.charAt(0).toUpperCase()}#{event.substr(1, event.length-1)}"]
      cb() if cb
      true
    else
      false

  workflowState: -> @model.get(@attrName)