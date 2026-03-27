/* eslint-disable */
import type { DefineMethods } from 'aspida';
import type * as Types from '../../../@types';

export type Methods = DefineMethods<{
  /** ログインユーザーの過去6ヶ月実績・将来6ヶ月見込の稼働時間を返す */
  get: {
    status: 200;
    /** 取得成功 */
    resBody: Types.WorkingHoursDetail;
  };
}>;
