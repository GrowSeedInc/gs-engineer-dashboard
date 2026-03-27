import type { AspidaClient, BasicHeaders } from 'aspida';
import { dataToURLString } from 'aspida';
import type { Methods as Methods_4ysq5b } from './api/v1/auth/sign_in';
import type { Methods as Methods_1qb6wdg } from './api/v1/auth/sign_out';
import type { Methods as Methods_switch } from './api/v1/auth/switch';
import type { Methods as Methods_7byf1q } from './api/v1/contracts';
import type { Methods as Methods_1qjy22h } from './api/v1/dashboard';
import type { Methods as Methods_1hwk7kl } from './api/v1/return_rate_trends';
import type { Methods as Methods_t4vhv2 } from './api/v1/sales_trends';
import type { Methods as Methods_1kpl64y } from './api/v1/working_hours';
import type { Methods as Methods_users } from './api/v1/users';

const api = <T>({ baseURL, fetch }: AspidaClient<T>) => {
  const prefix = (baseURL === undefined ? 'http://localhost:3000' : baseURL).replace(/\/$/, '');
  const PATH0 = '/api/v1/auth/sign_in';
  const PATH1 = '/api/v1/auth/sign_out';
  const PATH_SWITCH = '/api/v1/auth/switch';
  const PATH2 = '/api/v1/contracts';
  const PATH3 = '/api/v1/dashboard';
  const PATH4 = '/api/v1/return_rate_trends';
  const PATH5 = '/api/v1/sales_trends';
  const PATH6 = '/api/v1/working_hours';
  const PATH_USERS = '/api/v1/users';
  const GET = 'GET';
  const POST = 'POST';
  const DELETE = 'DELETE';

  return {
    api: {
      v1: {
        auth: {
          sign_in: {
            /**
             * @returns ログイン成功
             */
            post: (option: { body: Methods_4ysq5b['post']['reqBody'], config?: T | undefined }) =>
              fetch<Methods_4ysq5b['post']['resBody'], BasicHeaders, Methods_4ysq5b['post']['status']>(prefix, PATH0, POST, option).json(),
            /**
             * @returns ログイン成功
             */
            $post: (option: { body: Methods_4ysq5b['post']['reqBody'], config?: T | undefined }) =>
              fetch<Methods_4ysq5b['post']['resBody'], BasicHeaders, Methods_4ysq5b['post']['status']>(prefix, PATH0, POST, option).json().then(r => r.body),
            $path: () => `${prefix}${PATH0}`,
          },
          sign_out: {
            delete: (option?: { config?: T | undefined } | undefined) =>
              fetch<void, BasicHeaders, Methods_1qb6wdg['delete']['status']>(prefix, PATH1, DELETE, option).send(),
            $delete: (option?: { config?: T | undefined } | undefined) =>
              fetch<void, BasicHeaders, Methods_1qb6wdg['delete']['status']>(prefix, PATH1, DELETE, option).send().then(r => r.body),
            $path: () => `${prefix}${PATH1}`,
          },
          switch: {
            /**
             * @returns ユーザー切り替え成功
             */
            post: (option: { body: Methods_switch['post']['reqBody'], config?: T | undefined }) =>
              fetch<Methods_switch['post']['resBody'], BasicHeaders, Methods_switch['post']['status']>(prefix, PATH_SWITCH, POST, option).json(),
            /**
             * @returns ユーザー切り替え成功
             */
            $post: (option: { body: Methods_switch['post']['reqBody'], config?: T | undefined }) =>
              fetch<Methods_switch['post']['resBody'], BasicHeaders, Methods_switch['post']['status']>(prefix, PATH_SWITCH, POST, option).json().then(r => r.body),
            $path: () => `${prefix}${PATH_SWITCH}`,
          },
        },
        contracts: {
          /**
           * ログインユーザーの受注契約一覧と月別受注状況を返す
           * @returns 取得成功
           */
          get: (option?: { query?: Methods_7byf1q['get']['query'] | undefined, config?: T | undefined } | undefined) =>
            fetch<Methods_7byf1q['get']['resBody'], BasicHeaders, Methods_7byf1q['get']['status']>(prefix, PATH2, GET, option).json(),
          /**
           * ログインユーザーの受注契約一覧と月別受注状況を返す
           * @returns 取得成功
           */
          $get: (option?: { query?: Methods_7byf1q['get']['query'] | undefined, config?: T | undefined } | undefined) =>
            fetch<Methods_7byf1q['get']['resBody'], BasicHeaders, Methods_7byf1q['get']['status']>(prefix, PATH2, GET, option).json().then(r => r.body),
          $path: (option?: { method?: 'get' | undefined; query: Methods_7byf1q['get']['query'] } | undefined) =>
            `${prefix}${PATH2}${option && option.query ? `?${dataToURLString(option.query)}` : ''}`,
        },
        dashboard: {
          /**
           * ログインユーザーの月額給与・月額単価・還元率を返す
           * @returns 取得成功
           */
          get: (option?: { config?: T | undefined } | undefined) =>
            fetch<Methods_1qjy22h['get']['resBody'], BasicHeaders, Methods_1qjy22h['get']['status']>(prefix, PATH3, GET, option).json(),
          /**
           * ログインユーザーの月額給与・月額単価・還元率を返す
           * @returns 取得成功
           */
          $get: (option?: { config?: T | undefined } | undefined) =>
            fetch<Methods_1qjy22h['get']['resBody'], BasicHeaders, Methods_1qjy22h['get']['status']>(prefix, PATH3, GET, option).json().then(r => r.body),
          $path: () => `${prefix}${PATH3}`,
        },
        return_rate_trends: {
          /**
           * ログインユーザーの月別還元率推移を返す
           * @returns 取得成功
           */
          get: (option?: { query?: Methods_1hwk7kl['get']['query'] | undefined, config?: T | undefined } | undefined) =>
            fetch<Methods_1hwk7kl['get']['resBody'], BasicHeaders, Methods_1hwk7kl['get']['status']>(prefix, PATH4, GET, option).json(),
          /**
           * ログインユーザーの月別還元率推移を返す
           * @returns 取得成功
           */
          $get: (option?: { query?: Methods_1hwk7kl['get']['query'] | undefined, config?: T | undefined } | undefined) =>
            fetch<Methods_1hwk7kl['get']['resBody'], BasicHeaders, Methods_1hwk7kl['get']['status']>(prefix, PATH4, GET, option).json().then(r => r.body),
          $path: (option?: { method?: 'get' | undefined; query: Methods_1hwk7kl['get']['query'] } | undefined) =>
            `${prefix}${PATH4}${option && option.query ? `?${dataToURLString(option.query)}` : ''}`,
        },
        sales_trends: {
          /**
           * ログインユーザーの月別売上実績・予測を返す
           * @returns 取得成功
           */
          get: (option?: { query?: Methods_t4vhv2['get']['query'] | undefined, config?: T | undefined } | undefined) =>
            fetch<Methods_t4vhv2['get']['resBody'], BasicHeaders, Methods_t4vhv2['get']['status']>(prefix, PATH5, GET, option).json(),
          /**
           * ログインユーザーの月別売上実績・予測を返す
           * @returns 取得成功
           */
          $get: (option?: { query?: Methods_t4vhv2['get']['query'] | undefined, config?: T | undefined } | undefined) =>
            fetch<Methods_t4vhv2['get']['resBody'], BasicHeaders, Methods_t4vhv2['get']['status']>(prefix, PATH5, GET, option).json().then(r => r.body),
          $path: (option?: { method?: 'get' | undefined; query: Methods_t4vhv2['get']['query'] } | undefined) =>
            `${prefix}${PATH5}${option && option.query ? `?${dataToURLString(option.query)}` : ''}`,
        },
        working_hours: {
          /**
           * ログインユーザーの過去6ヶ月実績・将来6ヶ月見込の稼働時間を返す
           * @returns 取得成功
           */
          get: (option?: { config?: T | undefined } | undefined) =>
            fetch<Methods_1kpl64y['get']['resBody'], BasicHeaders, Methods_1kpl64y['get']['status']>(prefix, PATH6, GET, option).json(),
          /**
           * ログインユーザーの過去6ヶ月実績・将来6ヶ月見込の稼働時間を返す
           * @returns 取得成功
           */
          $get: (option?: { config?: T | undefined } | undefined) =>
            fetch<Methods_1kpl64y['get']['resBody'], BasicHeaders, Methods_1kpl64y['get']['status']>(prefix, PATH6, GET, option).json().then(r => r.body),
          $path: () => `${prefix}${PATH6}`,
        },
        users: {
          /**
           * ユーザー一覧を返す
           * @returns 取得成功
           */
          get: (option?: { config?: T | undefined } | undefined) =>
            fetch<Methods_users['get']['resBody'], BasicHeaders, Methods_users['get']['status']>(prefix, PATH_USERS, GET, option).json(),
          /**
           * ユーザー一覧を返す
           * @returns 取得成功
           */
          $get: (option?: { config?: T | undefined } | undefined) =>
            fetch<Methods_users['get']['resBody'], BasicHeaders, Methods_users['get']['status']>(prefix, PATH_USERS, GET, option).json().then(r => r.body),
          $path: () => `${prefix}${PATH_USERS}`,
        },
      },
    },
  };
};

export type ApiInstance = ReturnType<typeof api>;
export default api;
