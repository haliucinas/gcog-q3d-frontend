import { createStore, compose, combineReducers, applyMiddleware } from 'redux'

import reducers from './reducers'

middlewares = applyMiddleware()

store = createStore(
    combineReducers(reducers)
    undefined
    compose(middlewares)
)

export default store