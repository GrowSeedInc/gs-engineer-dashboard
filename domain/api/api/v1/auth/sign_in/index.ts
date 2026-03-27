/* eslint-disable */
import type { DefineMethods } from 'aspida';
import type * as Types from '../../../../@types';

export type Methods = DefineMethods<{
  post: {
    status: 200;

    /** ログイン成功 */
    resBody: {
      /** JWTトークン */
      token: string;
      user: Types.User;
    };

    reqBody: {
      email: string;
      password: string;
    };
  };
}>;
