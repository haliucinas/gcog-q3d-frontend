import { Route, HashRouter, Switch } from 'inferno-router'
import { Provider } from 'inferno-redux'

import store from './store'
import Base from './containers/Base'
import Home from './containers/Home'
import NotFound from './containers/NotFound'

Router = () =>
    <Provider store={store}>
        <HashRouter>
            <Base>
                <Switch>
                    <Route exact path='/' component={Home} />
                    <Route component={NotFound} />
                </Switch>
            </Base>
        </HashRouter>
    </Provider>

export default Router