class NotFound extends Component
    componentWillMount: ->
        document.title = 'GCOG | 404'

    render:  ->
        <div class='center'>404: {"'#{@props.location.pathname}'"} not found</div>

export default NotFound