import { withRouter } from 'inferno-router'

class Base extends Component
    render: (props) -> 
        <div id='content'>
            {props.children}
        </div>

export default withRouter(Base)